<script lang="ts">
    import type { DetectedDataSource } from "$lib/model/Data";
    import { getAllSensorTypes, type SensorType } from "$lib/stores/sensorTypes";
    import { Button } from "$lib/components/ui/button";
    import { Checkbox } from "$lib/components/ui/checkbox";
    import { Label } from "$lib/components/ui/label";
    import { Badge } from "$lib/components/ui/badge";

    interface Props {
        hubData: {
            serialNumber: string;
            displayName: string;
            description: string;
            location: string;
        };
        onSubmit: (selectedDataSources: DetectedDataSource[]) => void;
        onBack: () => void;
    }

    let { hubData, onSubmit, onBack }: Props = $props();

    // Generate detected data sources from the sensor store
    let detectedDataSources = $state<DetectedDataSource[]>(
        getAllSensorTypes().map(sensorType => ({
            type: sensorType.id,
            displayName: sensorType.displayName,
            description: sensorType.description,
            selected: sensorType.defaultSelected
        }))
    );

    let isSubmitting = $state(false);

    function toggleDataSource(index: number) {
        detectedDataSources[index].selected = !detectedDataSources[index].selected;
    }

    function selectAll() {
        detectedDataSources.forEach(ds => ds.selected = true);
    }

    function selectNone() {
        detectedDataSources.forEach(ds => ds.selected = false);
    }

    function handleSubmit() {
        const selectedSources = detectedDataSources.filter(ds => ds.selected);
        if (selectedSources.length === 0) {
            return;
        }

        isSubmitting = true;
        onSubmit(selectedSources);
    }

    let selectedCount = $derived(detectedDataSources.filter(ds => ds.selected).length);
</script>

<div class="space-y-4">
        <p class="text-sm text-muted-foreground">
            We've detected the following data sources on your hub. Select which ones you'd like to monitor.
        </p>
        <div class="flex gap-2 mb-4">
            <Button variant="outline" size="sm" onclick={selectAll}>
                Select All
            </Button>
            <Button variant="outline" size="sm" onclick={selectNone}>
                Select None
            </Button>
            <div class="ml-auto text-sm text-muted-foreground">
                {selectedCount} of {detectedDataSources.length} selected
            </div>
        </div>

        <div class="grid gap-3">
            {#each detectedDataSources as dataSource, index}
                {@const sensorType = getAllSensorTypes().find(s => s.id === dataSource.type)}
                <div class="flex items-start space-x-3 p-3 border rounded-lg hover:bg-muted/50 transition-colors">
                    <Checkbox
                        id="ds-{index}"
                        checked={dataSource.selected}
                        onCheckedChange={() => toggleDataSource(index)}
                        disabled={isSubmitting}
                    />
                    <div class="flex items-center space-x-3 flex-1">
                        {#if sensorType}
                            <div class="p-2 rounded-lg bg-muted">
                                <sensorType.icon class="w-5 h-5" />
                            </div>
                        {/if}
                        <div class="flex-1 space-y-1">
                            <div class="flex items-center gap-2">
                                <Label for="ds-{index}" class="text-sm font-medium cursor-pointer">
                                    {dataSource.displayName}
                                </Label>
                                {#if sensorType}
                                    <Badge variant="outline" class={sensorType.colorClass}>
                                        {sensorType.category}
                                    </Badge>
                                {/if}
                            </div>
                            <p class="text-xs text-muted-foreground">
                                {dataSource.description}
                            </p>
                            {#if sensorType}
                                <div class="text-xs text-muted-foreground">
                                    Unit: {sensorType.unit || "N/A"}
                                </div>
                            {/if}
                        </div>
                    </div>
                </div>
            {/each}
        </div>

        <div class="flex gap-2 pt-4">
            <Button
                onclick={handleSubmit}
                disabled={selectedCount === 0 || isSubmitting}
                class="flex-1"
            >
                {isSubmitting ? "Creating Hub..." : `Create Hub with ${selectedCount} Data Sources`}
            </Button>
            <Button variant="outline" onclick={onBack} disabled={isSubmitting}>
                Back
            </Button>
        </div>
</div>
