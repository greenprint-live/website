<script lang="ts">
    import type { GPDataSource } from "$lib/model/Data";
    import { getSensorType } from "$lib/stores/sensorTypes";
    import BaseSensorCard from "./BaseSensorCard.svelte";

    interface Props {
        dataSource: GPDataSource;
        currentValue: number;
        lastUpdated: string;
        trend?: "up" | "down" | "stable";
        status?: "active" | "inactive" | "error";
    }

    let { 
        dataSource, 
        currentValue, 
        lastUpdated, 
        trend = "stable",
        status = "active" 
    }: Props = $props();

    const sensorType = getSensorType("light");

    // Light-specific logic
    function getLightLevel(lux: number) {
        if (lux < 10) return "Dark";
        if (lux < 50) return "Dim";
        if (lux < 200) return "Indoor";
        if (lux < 500) return "Office";
        if (lux < 1000) return "Bright";
        return "Very Bright";
    }

    function getLightColor(lux: number) {
        if (lux < 10) return "text-gray-600";
        if (lux < 50) return "text-blue-600";
        if (lux < 200) return "text-green-600";
        if (lux < 500) return "text-yellow-600";
        return "text-orange-600";
    }

    let computedStatus = $derived(status);
</script>

<BaseSensorCard 
    {dataSource} 
    {sensorType} 
    currentValue={Math.round(currentValue).toString()} 
    {lastUpdated} 
    {trend} 
    status={computedStatus}
>
    <!-- Light-specific content -->
    <div class="mt-4 pt-4 border-t">
        <div class="flex justify-between text-xs text-muted-foreground">
            <span>Light Level:</span>
            <span class={getLightColor(currentValue)}>
                {getLightLevel(currentValue)}
            </span>
        </div>
    </div>
</BaseSensorCard>
