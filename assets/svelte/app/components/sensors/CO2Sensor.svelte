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

    const sensorType = getSensorType("co2");

    // CO2-specific logic
    function getCO2Status(co2: number): "active" | "inactive" | "error" {
        if (co2 < 0 || co2 > 5000) return "error";
        if (co2 > 1000) return "inactive";
        return "active";
    }

    function getCO2Level(co2: number) {
        if (co2 < 400) return "Excellent";
        if (co2 < 600) return "Good";
        if (co2 < 1000) return "Acceptable";
        if (co2 < 1500) return "Poor";
        return "Dangerous";
    }

    function getCO2Color(co2: number) {
        if (co2 < 400) return "text-green-600";
        if (co2 < 600) return "text-blue-600";
        if (co2 < 1000) return "text-yellow-600";
        if (co2 < 1500) return "text-orange-600";
        return "text-red-600";
    }

    let computedStatus = $derived(status === "active" ? getCO2Status(currentValue) : status);
</script>

<BaseSensorCard 
    {dataSource} 
    {sensorType} 
    currentValue={Math.round(currentValue).toString()} 
    {lastUpdated} 
    {trend} 
    status={computedStatus}
>
    <!-- CO2-specific content -->
    <div class="mt-4 pt-4 border-t">
        <div class="flex justify-between text-xs text-muted-foreground">
            <span>Air Quality:</span>
            <span class={getCO2Color(currentValue)}>
                {getCO2Level(currentValue)}
            </span>
        </div>
    </div>
</BaseSensorCard>
