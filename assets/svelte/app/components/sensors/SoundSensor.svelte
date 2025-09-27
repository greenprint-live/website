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

    const sensorType = getSensorType("sound");

    // Sound-specific logic
    function getSoundLevel(db: number) {
        if (db < 30) return "Very Quiet";
        if (db < 40) return "Quiet";
        if (db < 55) return "Moderate";
        if (db < 70) return "Loud";
        if (db < 85) return "Very Loud";
        return "Dangerous";
    }

    function getSoundColor(db: number) {
        if (db < 30) return "text-blue-600";
        if (db < 40) return "text-green-600";
        if (db < 55) return "text-yellow-600";
        if (db < 70) return "text-orange-600";
        if (db < 85) return "text-red-600";
        return "text-red-800";
    }

    function getSoundStatus(db: number): "active" | "inactive" | "error" {
        if (db > 85) return "error";
        if (db > 70) return "inactive";
        return "active";
    }

    let computedStatus = $derived(status === "active" ? getSoundStatus(currentValue) : status);
</script>

<BaseSensorCard 
    {dataSource} 
    {sensorType} 
    currentValue={currentValue.toFixed(1)} 
    {lastUpdated} 
    {trend} 
    status={computedStatus}
>
    <!-- Sound-specific content -->
    <div class="mt-4 pt-4 border-t">
        <div class="flex justify-between text-xs text-muted-foreground">
            <span>Noise Level:</span>
            <span class={getSoundColor(currentValue)}>
                {getSoundLevel(currentValue)}
            </span>
        </div>
    </div>
</BaseSensorCard>
