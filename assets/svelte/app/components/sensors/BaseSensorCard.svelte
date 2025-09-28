<script lang="ts">
    import type { GPDataSource } from "$lib/model/Data";
    import type { SensorType } from "$lib/stores/sensorTypes";
    import { Card, CardHeader, CardTitle, CardContent } from "$lib/components/ui/card";
    import { Badge } from "$lib/components/ui/badge";

    interface Props {
        dataSource: GPDataSource;
        sensorType: SensorType;
        currentValue: string;
        lastUpdated: string;
        trend?: "up" | "down" | "stable";
        status?: "active" | "inactive" | "error";
    }

    let { 
        dataSource, 
        sensorType, 
        currentValue, 
        lastUpdated, 
        trend = "stable",
        status = "active" 
    }: Props = $props();

    function getStatusColor(status: string) {
        switch (status) {
            case "active": return "text-green-600";
            case "inactive": return "text-yellow-600";
            case "error": return "text-red-600";
            default: return "text-gray-600";
        }
    }

    function getTrendIcon(trend: string) {
        switch (trend) {
            case "up": return "↗";
            case "down": return "↘";
            case "stable": return "→";
            default: return "→";
        }
    }

    function getTrendColor(trend: string) {
        switch (trend) {
            case "up": return "text-green-600";
            case "down": return "text-red-600";
            case "stable": return "text-gray-600";
            default: return "text-gray-600";
        }
    }
</script>

<Card class="h-full">
    <CardHeader class="pb-3">
        <div class="flex items-center justify-between">
            <CardTitle class="text-lg">{dataSource.displayName}</CardTitle>
            <Badge class={sensorType.colorClass}>
                {sensorType.id}
            </Badge>
        </div>
        <p class="text-sm text-muted-foreground">{dataSource.description}</p>
        <a class="text-sm text-muted-foreground underline" href={`mailto:${dataSource.agentMailInbox}`}>{dataSource.agentMailInbox}</a>
    </CardHeader>
    <CardContent>
        <div class="flex items-center gap-4 mb-4">
            <div class="p-2 rounded-lg bg-muted">
                <sensorType.icon class="w-6 h-6" />
            </div>
            <div>
                <div class="text-2xl font-bold">
                    {currentValue}{sensorType.unit}
                </div>
                <div class="text-xs text-muted-foreground">
                    Last updated: {lastUpdated}
                </div>
            </div>
        </div>
        
        <div class="space-y-2">
            <div class="flex justify-between text-sm">
                <span>Status:</span>
                <Badge variant="outline" class={getStatusColor(status)}>
                    {status}
                </Badge>
            </div>
            <div class="flex justify-between text-sm">
                <span>Trend:</span>
                <span class={getTrendColor(trend)}>
                    {getTrendIcon(trend)} {trend}
                </span>
            </div>
        </div>

        <!-- Slot for sensor-specific content -->
        <slot />
    </CardContent>
</Card>
