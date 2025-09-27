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

    const sensorType = getSensorType("humidity");

    // Humidity-specific logic
    function getHumidityStatus(humidity: number): "active" | "inactive" | "error" {
        if (humidity < 0 || humidity > 100) return "error";
        if (humidity < 30 || humidity > 70) return "inactive";
        return "active";
    }

    function getHumidityLevel(humidity: number) {
        if (humidity < 30) return "Too Dry";
        if (humidity > 70) return "Too Humid";
        if (humidity >= 40 && humidity <= 60) return "Ideal";
        return "Acceptable";
    }

    function getHumidityColor(humidity: number) {
        if (humidity < 30 || humidity > 70) return "text-yellow-600";
        if (humidity >= 40 && humidity <= 60) return "text-green-600";
        return "text-blue-600";
    }

    let computedStatus = $derived(status === "active" ? getHumidityStatus(currentValue) : status);
</script>

<BaseSensorCard 
    {dataSource} 
    {sensorType} 
    currentValue={currentValue.toFixed(1)} 
    {lastUpdated} 
    {trend} 
    status={computedStatus}
>
    <!-- Humidity-specific content -->
    <div class="mt-4 pt-4 border-t">
        <div class="flex justify-between text-xs text-muted-foreground">
            <span>Comfort Level:</span>
            <span class={getHumidityColor(currentValue)}>
                {getHumidityLevel(currentValue)}
            </span>
        </div>
    </div>
</BaseSensorCard>
