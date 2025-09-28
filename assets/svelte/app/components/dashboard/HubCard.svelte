<script lang="ts">
    import type { GPHub } from "$lib/model/Data";
    import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "$lib/components/ui/card";
    import { Badge } from "$lib/components/ui/badge";
    import { Button } from "$lib/components/ui/button";
    import { 
        Dialog, 
        DialogContent, 
        DialogHeader, 
        DialogTitle,
        DialogDescription,
        DialogFooter
    } from "$lib/components/ui/dialog";
    
    interface Props {
        hub: GPHub;
        onDelete?: (hubId: string) => void;
    }

    let { hub, onDelete }: Props = $props();
    let deleteDialogOpen = $state(false);

    // Calculate time since last update
    function getTimeAgo(dateString: string): string {
        const date = new Date(dateString);
        const now = new Date();
        const diffInMinutes = Math.floor((now.getTime() - date.getTime()) / (1000 * 60));
        
        if (diffInMinutes < 1) return "Just now";
        if (diffInMinutes < 60) return `${diffInMinutes}m ago`;
        
        const diffInHours = Math.floor(diffInMinutes / 60);
        if (diffInHours < 24) return `${diffInHours}h ago`;
        
        const diffInDays = Math.floor(diffInHours / 24);
        if (diffInDays < 7) return `${diffInDays}d ago`;
        
        return date.toLocaleDateString();
    }

    // Determine status based on last update time
    function getHubStatus(dateString: string): { status: string; color: string } {
        const date = new Date(dateString);
        const now = new Date();
        const diffInMinutes = Math.floor((now.getTime() - date.getTime()) / (1000 * 60));
        
        if (diffInMinutes < 5) return { status: "Online", color: "green" };
        if (diffInMinutes < 60) return { status: "Recent", color: "yellow" };
        return { status: "Offline", color: "gray" };
    }

    let hubStatus = $derived(getHubStatus(hub.updatedAt));
    let timeAgo = $derived(getTimeAgo(hub.updatedAt));

    function handleDeleteClick(event: Event) {
        event.preventDefault();
        event.stopPropagation();
        deleteDialogOpen = true;
    }

    function confirmDelete() {
        if (onDelete) {
            onDelete(hub.id);
        }
        deleteDialogOpen = false;
    }

    function cancelDelete() {
        deleteDialogOpen = false;
    }
</script>

<div class="group">
    <Card class="h-full transition-all duration-300 hover:shadow-xl hover:-translate-y-1 border-l-4 border-l-primary/20 hover:border-l-primary group-hover:bg-gradient-to-br group-hover:from-background group-hover:to-muted/10">
        <CardHeader class="pb-3">
            <div class="flex items-start justify-between">
                <div class="flex-1">
                    <div class="flex items-center gap-2 mb-1">
                        <CardTitle class="text-lg font-bold text-foreground group-hover:text-primary transition-colors">
                            {hub.displayName}
                        </CardTitle>
                        <div class="flex items-center gap-1">
                            <Badge variant="secondary" class="text-xs px-2 py-0 h-5" style="color: {hubStatus.color}">
                                {hubStatus.status}
                            </Badge>
                        </div>
                    </div>
                    <CardDescription class="text-xs text-muted-foreground font-mono">
                        #{hub.serialNumber}
                    </CardDescription>
                </div>
                <div class="p-2 bg-primary/10 rounded-lg group-hover:bg-primary/20 transition-colors">
                    <svg class="w-5 h-5 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 3v2m6-2v2M9 19v2m6-2v2M5 9H3m2 6H3m18-6h-2m2 6h-2M7 19h10a2 2 0 002-2V7a2 2 0 00-2-2H7a2 2 0 00-2 2v10a2 2 0 002 2zM9 9h6v6H9V9z"/>
                    </svg>
                </div>
            </div>
        </CardHeader>
        
        <CardContent class="pt-0 cursor-pointer">
            <div class="space-y-3">
                {#if hub.description}
                    <p class="text-sm text-muted-foreground line-clamp-2 leading-relaxed">
                        {hub.description}
                    </p>
                {/if}
                
                {#if hub.location}
                    <div class="flex items-center gap-2 text-sm text-muted-foreground bg-muted/30 rounded-md px-2 py-1">
                        <svg class="w-4 h-4 text-muted-foreground/70" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/>
                        </svg>
                        <span class="truncate">{hub.location}</span>
                    </div>
                {/if}
                
                <div class="flex items-center justify-between pt-2 border-t border-muted/30">
                    <div class="flex items-center gap-2 text-xs text-muted-foreground">
                        <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                        {timeAgo}
                    </div>
                    <div class="flex items-center gap-2">
                        <a href={`/dashboard/hub/${hub.id}`} class="text-xs text-primary font-medium group-hover:underline hover:underline">
                            View Details →
                        </a>
                        {#if onDelete}
                            <Button
                                variant="ghost"
                                size="icon"
                                onclick={handleDeleteClick}
                                class="p-1 h-auto text-destructive hover:text-destructive hover:bg-destructive/10 transition-colors"
                                aria-label="Delete hub"
                            >
                                <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                </svg>
                            </Button>
                        {/if}
                    </div>
                </div>
            </div>
        </CardContent>
    </Card>
</div>

<!-- Delete Confirmation Dialog -->
<Dialog bind:open={deleteDialogOpen}>
    <DialogContent class="max-w-md">
        <DialogHeader>
            <DialogTitle class="flex items-center gap-2 text-destructive">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z"/>
                </svg>
                Delete Hub
            </DialogTitle>
            <DialogDescription class="space-y-2">
                <p>Are you sure you want to delete <strong>"{hub.displayName}"</strong>?</p>
                <p class="text-sm text-muted-foreground">
                    This will permanently remove the hub and all its data sources. This action cannot be undone.
                </p>
            </DialogDescription>
        </DialogHeader>
        <DialogFooter class="gap-2">
            <Button variant="outline" onclick={cancelDelete}>
                Cancel
            </Button>
            <Button variant="destructive" onclick={confirmDelete}>
                Delete Hub
            </Button>
        </DialogFooter>
    </DialogContent>
</Dialog>