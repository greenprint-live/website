<script lang="ts">
    import type { User } from "$lib/model/User";
    import type { GPHub, DetectedDataSource } from "$lib/model/Data";
    import type { LiveSocket } from "phoenix_live_view";
    import Navbar from "../components/Navbar.svelte";
    import HubCard from "../components/dashboard/HubCard.svelte";
    import CreateHubForm from "../components/dashboard/CreateHubForm.svelte";
    import DataSourceSelection from "../components/dashboard/DataSourceSelection.svelte";
    import { Card, CardHeader, CardTitle, CardContent } from "$lib/components/ui/card";
    import { Button } from "$lib/components/ui/button";
    import { 
        Dialog, 
        DialogContent, 
        DialogHeader, 
        DialogTitle,
        DialogDescription 
    } from "$lib/components/ui/dialog";

    interface Props {
        socket: typeof LiveSocket;
        current_user: User;
        hubs: GPHub[];
    }

    let { socket, current_user, hubs }: Props = $props();

    type CreateHubStep = "hub_form" | "data_source_selection";
    let dialogOpen = $state(false);
    let currentStep: CreateHubStep = $state("hub_form");
    let hubFormData = $state<{
        serialNumber: string;
        displayName: string;
        description: string;
        location: string;
    } | null>(null);

    function startCreateHub() {
        currentStep = "hub_form";
        hubFormData = null;
        dialogOpen = true;
    }

    function closeDialog() {
        dialogOpen = false;
        currentStep = "hub_form";
        hubFormData = null;
    }

    function handleHubFormSubmit(data: {
        serialNumber: string;
        displayName: string;
        description: string;
        location: string;
    }) {
        hubFormData = data;
        currentStep = "data_source_selection";
    }

    function goBackToHubForm() {
        currentStep = "hub_form";
    }

    async function handleDataSourceSelection(selectedDataSources: DetectedDataSource[]) {
        if (!hubFormData) return;

        try {
            // Create the hub first
            const hubResponse = await fetch("/api/hubs", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')?.getAttribute("content") || ""
                },
                body: JSON.stringify({
                    hub: {
                        serial_number: hubFormData.serialNumber,
                        display_name: hubFormData.displayName,
                        description: hubFormData.description,
                        location: hubFormData.location
                    }
                })
            });

            if (!hubResponse.ok) {
                throw new Error("Failed to create hub");
            }

            const hubResult = await hubResponse.json();
            
            if (!hubResult.success) {
                throw new Error("Hub creation failed");
            }

            const hubId = hubResult.hub.id;

            // Create the data sources
            const dataSourcesPayload = selectedDataSources.map(ds => ({
                display_name: ds.displayName,
                description: ds.description,
                type: ds.type
            }));

            const dataSourceResponse = await fetch(`/api/hubs/${hubId}/data_sources`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')?.getAttribute("content") || ""
                },
                body: JSON.stringify({
                    data_sources: dataSourcesPayload
                })
            });

            if (!dataSourceResponse.ok) {
                throw new Error("Failed to create data sources");
            }

            // Close dialog and navigate to the hub display page
            closeDialog();
            window.location.href = `/dashboard/hub/${hubId}`;

        } catch (error) {
            console.error("Error creating hub:", error);
            alert("Failed to create hub. Please try again.");
        }
    }
</script>

<Navbar current_user={current_user} />

<div class="grid grid-cols-1 gap-4 grid-flow-row md:grid-cols-2 lg:grid-cols-3">
    {#each hubs as hub}
        <HubCard hub={hub} />
    {/each}

    <Card>
        <CardHeader>
            <CardTitle>Add Hub</CardTitle>
        </CardHeader>
        <CardContent>
            <Button onclick={startCreateHub}>Add Hub</Button>
        </CardContent>
    </Card>
</div>

<Dialog bind:open={dialogOpen}>
    <DialogContent class="max-w-2xl max-h-[90vh] overflow-y-auto">
        {#if currentStep === "hub_form"}
            <DialogHeader>
                <DialogTitle>Register New Hub</DialogTitle>
                <DialogDescription>
                    Enter the details for your new hub to get started with monitoring.
                </DialogDescription>
            </DialogHeader>
            <CreateHubForm 
                onSubmit={handleHubFormSubmit}
                onCancel={closeDialog}
            />
        {:else if currentStep === "data_source_selection"}
            <DialogHeader>
                <DialogTitle>Select Data Sources</DialogTitle>
                <DialogDescription>
                    Choose which data sources you'd like to monitor for "{hubFormData?.displayName}".
                </DialogDescription>
            </DialogHeader>
            <DataSourceSelection 
                hubData={hubFormData!}
                onSubmit={handleDataSourceSelection}
                onBack={goBackToHubForm}
            />
        {/if}
    </DialogContent>
</Dialog>
