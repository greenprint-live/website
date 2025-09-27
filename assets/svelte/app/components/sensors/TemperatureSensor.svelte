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

    const sensorType = getSensorType("temperature");

    // Temperature-specific logic
    function getTemperatureStatus(temp: number): "active" | "inactive" | "error" {
        if (temp < 0 || temp > 40) return "error";
        if (temp < 10 || temp > 30) return "inactive";
        return "active";
    }

    function getTemperatureColor(temp: number) {
        if (temp < 15) return "text-blue-600";
        if (temp > 25) return "text-red-600";
        return "text-green-600";
    }

    let computedStatus = $derived(status === "active" ? getTemperatureStatus(currentValue) : status);
</script>

<BaseSensorCard 
    {dataSource} 
    {sensorType} 
    currentValue={currentValue.toFixed(1)} 
    {lastUpdated} 
    {trend} 
    status={computedStatus}
>
    <!-- Temperature-specific content -->
    <div class="mt-4 pt-4 border-t">
        <div class="flex justify-between text-xs text-muted-foreground">
            <span>Comfort Range:</span>
            <span class={getTemperatureColor(currentValue)}>
                {currentValue < 18 ? "Too Cold" : currentValue > 24 ? "Too Warm" : "Comfortable"}
            </span>
        </div>
    </div>
</BaseSensorCard>
