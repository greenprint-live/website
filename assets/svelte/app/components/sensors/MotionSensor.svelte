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

    const sensorType = getSensorType("motion");

    // Motion-specific logic
    function getMotionLevel(eventsPerHour: number) {
        if (eventsPerHour === 0) return "No Motion";
        if (eventsPerHour < 5) return "Low Activity";
        if (eventsPerHour < 15) return "Moderate Activity";
        if (eventsPerHour < 30) return "High Activity";
        return "Very High Activity";
    }

    function getMotionColor(eventsPerHour: number) {
        if (eventsPerHour === 0) return "text-gray-600";
        if (eventsPerHour < 5) return "text-blue-600";
        if (eventsPerHour < 15) return "text-green-600";
        if (eventsPerHour < 30) return "text-yellow-600";
        return "text-red-600";
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
    <!-- Motion-specific content -->
    <div class="mt-4 pt-4 border-t">
        <div class="flex justify-between text-xs text-muted-foreground">
            <span>Activity Level:</span>
            <span class={getMotionColor(currentValue)}>
                {getMotionLevel(currentValue)}
            </span>
        </div>
    </div>
</BaseSensorCard>
