<script lang="ts">
    import { Card, CardHeader, CardTitle, CardContent } from "$lib/components/ui/card";
    import { Button } from "$lib/components/ui/button";
    import { Input } from "$lib/components/ui/input";
    import { Label } from "$lib/components/ui/label";
    // import { Textarea } from "$lib/components/ui/textarea";

    interface Props {
        onSubmit: (hubData: {
            serialNumber: string;
            displayName: string;
            description: string;
            location: string;
        }) => void;
        onCancel: () => void;
    }

    let { onSubmit, onCancel }: Props = $props();

    let serialNumber = $state("");
    let displayName = $state("");
    let description = $state("");
    let location = $state("");
    let isSubmitting = $state(false);

    function handleSubmit() {
        if (!serialNumber || !displayName || !description || !location) {
            return;
        }

        isSubmitting = true;
        onSubmit({
            serialNumber,
            displayName,
            description,
            location
        });
    }

    $effect(() => {
        // Reset submitting state if form is reset
        if (!serialNumber && !displayName && !description && !location) {
            isSubmitting = false;
        }
    });
</script>

<Card class="max-w-md mx-auto">
    <CardHeader>
        <CardTitle>Register New Hub</CardTitle>
    </CardHeader>
    <CardContent class="space-y-4">
        <div class="space-y-2">
            <Label for="serialNumber">Serial Number</Label>
            <Input
                id="serialNumber"
                bind:value={serialNumber}
                placeholder="Enter hub serial number"
                disabled={isSubmitting}
            />
        </div>

        <div class="space-y-2">
            <Label for="displayName">Display Name</Label>
            <Input
                id="displayName"
                bind:value={displayName}
                placeholder="Enter display name"
                disabled={isSubmitting}
            />
        </div>

        <div class="space-y-2">
            <Label for="description">Description</Label>
            <textarea
                id="description"
                bind:value={description}
                placeholder="Enter description"
                disabled={isSubmitting}
                class="flex min-h-[80px] w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
            ></textarea>
        </div>

        <div class="space-y-2">
            <Label for="location">Location</Label>
            <Input
                id="location"
                bind:value={location}
                placeholder="Enter location"
                disabled={isSubmitting}
            />
        </div>

        <div class="flex gap-2 pt-4">
            <Button
                onclick={handleSubmit}
                disabled={!serialNumber || !displayName || !description || !location || isSubmitting}
                class="flex-1"
            >
                {isSubmitting ? "Creating..." : "Next: Select Data Sources"}
            </Button>
            <Button variant="outline" onclick={onCancel} disabled={isSubmitting}>
                Cancel
            </Button>
        </div>
    </CardContent>
</Card>
