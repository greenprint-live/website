<script lang="ts">
    import { Button } from "$lib/components/ui/button";
    import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "$lib/components/ui/card";
    import { Checkbox } from "$lib/components/ui/checkbox";
    import { Label } from "$lib/components/ui/label";
    
    interface Props {
        title: string;
        subtitle?: string;
        submitText: string;
        isSubmitting?: boolean;
        showRememberMe?: boolean;
        children: any;
        links?: Array<{text: string, href: string}>;
        onSubmit: (data: FormData) => void;
    }

    let { 
        title, 
        subtitle, 
        submitText, 
        isSubmitting = false,
        showRememberMe = false,
        children,
        links = [],
        onSubmit 
    }: Props = $props();

    let formElement: HTMLFormElement;

    function handleSubmit(event: Event) {
        event.preventDefault();
        const formData = new FormData(formElement);
        onSubmit(formData);
    }
</script>

<Card class="w-full backdrop-blur-sm bg-card/80 border-border/40 shadow-xl">
    <CardHeader class="text-center space-y-1">
        <CardTitle class="text-2xl font-bold tracking-tight text-foreground">{title}</CardTitle>
        {#if subtitle}
            <CardDescription class="text-muted-foreground">{subtitle}</CardDescription>
        {/if}
    </CardHeader>
    
    <CardContent>
        <form bind:this={formElement} onsubmit={handleSubmit} class="space-y-6">
            <div class="space-y-4">
                {@render children()}
            </div>
            
            {#if showRememberMe}
                <div class="flex items-center space-x-2">
                    <Checkbox id="remember_me" name="remember_me" />
                    <Label 
                        for="remember_me" 
                        class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
                    >
                        Keep me logged in
                    </Label>
                </div>
            {/if}

            <Button 
                type="submit"
                disabled={isSubmitting}
                class="w-full"
                size="lg"
            >
                {#if isSubmitting}
                    <svg class="animate-spin -ml-1 mr-3 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    Processing...
                {:else}
                    {submitText}
                    <span aria-hidden="true" class="ml-2">→</span>
                {/if}
            </Button>
        </form>

        {#if links.length > 0}
            <div class="mt-6 text-center text-sm">
                {#each links as link, index}
                    <a href={link.href} class="font-medium text-primary hover:text-primary/80 transition-colors">
                        {link.text}
                    </a>
                    {#if index < links.length - 1}
                        <span class="mx-2 text-muted-foreground">|</span>
                    {/if}
                {/each}
            </div>
        {/if}
    </CardContent>
</Card>