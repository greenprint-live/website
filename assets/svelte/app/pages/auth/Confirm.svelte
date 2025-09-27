<script lang="ts">
    import AuthLayout from "../../components/auth/AuthLayout.svelte";
    import FormInput from "../../components/auth/FormInput.svelte";
    import { Button } from "$lib/components/ui/button";
    import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "$lib/components/ui/card";
    import type { LiveSocket } from "phoenix_live_view";

    interface Props {
        socket: any;
        mode?: 'confirm' | 'resend';
        token?: string;
        current_user?: any;
    }

    let { socket, mode = 'confirm', token, current_user }: Props = $props();

    let isSubmitting = $state(false);

    const links = [
        { text: "Sign in", href: "/auth/login" },
        { text: "Create account", href: "/auth/register" }
    ];
</script>

<AuthLayout {current_user}>
    <Card class="w-full backdrop-blur-sm bg-card/80 border-border/40 shadow-xl">
        {#if mode === 'confirm'}
            <CardHeader class="text-center space-y-4">
                <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-primary/20">
                    <svg class="h-6 w-6 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                    </svg>
                </div>
                <CardTitle class="text-2xl font-bold tracking-tight text-foreground">Confirm Your Account</CardTitle>
                <CardDescription>Click the button below to confirm your account and complete registration.</CardDescription>
            </CardHeader>
            
            <CardContent>
                <form class="space-y-4" {...{"phx-submit": "confirm_account"}}>
                    <input type="hidden" name="user[token]" value={token || ''} />
                    <Button 
                        type="submit"
                        class="w-full"
                        size="lg"
                        {...{"phx-disable-with": "Confirming..."}}
                    >
                        Confirm my account
                    </Button>
                </form>
            </CardContent>
        {:else}
            <CardHeader class="text-center space-y-4">
                <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-secondary">
                    <svg class="h-6 w-6 text-secondary-foreground" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                    </svg>
                </div>
                <CardTitle class="text-2xl font-bold tracking-tight text-foreground">No confirmation instructions received?</CardTitle>
                <CardDescription>We'll send a new confirmation link to your inbox</CardDescription>
            </CardHeader>
            
            <CardContent>
                <form class="space-y-4" {...{"phx-submit": "send_instructions"}}>
                    <FormInput
                        label="Email address"
                        name="user[email]"
                        type="email"
                        required={true}
                        placeholder="Enter your email"
                    />
                    
                    <Button 
                        type="submit"
                        class="w-full"
                        size="lg"
                        {...{"phx-disable-with": "Sending..."}}
                    >
                        Resend confirmation instructions
                    </Button>
                </form>
            </CardContent>
        {/if}

        <CardContent class="pt-0">
            <div class="text-center text-sm">
                {#each links as link, index}
                    <a href={link.href} class="font-medium text-primary hover:text-primary/80 transition-colors">
                        {link.text}
                    </a>
                    {#if index < links.length - 1}
                        <span class="mx-2 text-muted-foreground">|</span>
                    {/if}
                {/each}
            </div>
        </CardContent>
    </Card>
</AuthLayout>
