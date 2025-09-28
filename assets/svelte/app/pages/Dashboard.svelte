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

<div class="min-h-screen bg-gradient-to-br from-background to-muted/20">
    <div class="container mx-auto px-4 py-8">
        <!-- Page Header -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-foreground mb-2">Your Hubs</h1>
            <p class="text-muted-foreground">
                Monitor and manage your connected GreenPrint hubs
            </p>
        </div>

        <!-- Hub Grid -->
        <div class="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
            {#each hubs as hub}
                <HubCard {hub} />
            {/each}

            <!-- Add Hub Card -->
            <Card class="border-2 border-dashed border-muted-foreground/25 hover:border-primary/50 hover:bg-muted/25 transition-all duration-200 cursor-pointer group" onclick={startCreateHub}>
                <CardContent class="flex flex-col items-center justify-center p-8 text-center min-h-[200px]">
                    <div class="p-4">
                        <div class="bg-primary/10 rounded-full mb-4 group-hover:bg-primary/20 transition-colors">
                            <svg class="w-8 h-8 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                            </svg>
                        </div>
                        <h3 class="text-lg font-semibold text-foreground mb-2">Add New Hub</h3>
                        <p class="text-sm text-muted-foreground">
                            Connect a new environmental monitoring hub to your network
                        </p>
                    </div>
                </CardContent>
            </Card>
        </div>

        <!-- Empty State -->
        {#if hubs.length === 0}
            <div class="text-center py-16">
                <div class="max-w-md mx-auto">
                    <div class="p-6 bg-muted/20 rounded-full w-24 h-24 mx-auto mb-6 flex items-center justify-center">
                        <svg class="w-12 h-12 text-muted-foreground" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/>
                        </svg>
                    </div>
                    <h2 class="text-2xl font-bold text-foreground mb-4">No Hubs Connected</h2>
                    <p class="text-muted-foreground mb-8">
                        Get started by connecting your first environmental monitoring hub to begin tracking your data.
                    </p>
                    <Button onclick={startCreateHub} size="lg" class="px-8">
                        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                        </svg>
                        Add Your First Hub
                    </Button>
                </div>
            </div>
        {/if}
    </div>
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
