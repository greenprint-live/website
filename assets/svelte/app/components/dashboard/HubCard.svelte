<script lang="ts">
    import type { GPHub } from "$lib/model/Data";
    import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "$lib/components/ui/card";

    interface Props {
        hub: GPHub;
    }

    let { hub }: Props = $props();
</script>

<a href={`/dashboard/hub/${hub.id}`}>
    <Card 
        class="cursor-pointer transition-all duration-200 hover:shadow-lg hover:scale-[1.02] active:scale-[0.98]"
        role="button"
        tabindex={0}
    >
        <CardHeader>
            <CardTitle class="text-lg font-semibold text-foreground">
                {hub.displayName}
            </CardTitle>
            <CardDescription class="text-sm text-muted-foreground">
                Serial: {hub.serialNumber}
            </CardDescription>
        </CardHeader>
        
        <CardContent>
            <div class="space-y-2">
                {#if hub.description}
                    <p class="text-sm text-muted-foreground">
                        {hub.description}
                    </p>
                {/if}
                
                {#if hub.location}
                    <div class="flex items-center gap-2 text-sm text-muted-foreground">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/>
                        </svg>
                        {hub.location}
                    </div>
                {/if}
                
                <div class="text-xs text-muted-foreground pt-2">
                    Last updated: {new Date(hub.updatedAt).toLocaleDateString()}
                </div>
            </div>
        </CardContent>
    </Card>
</a>