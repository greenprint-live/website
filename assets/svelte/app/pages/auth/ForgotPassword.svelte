<script lang="ts">
    import AuthLayout from "../../components/auth/AuthLayout.svelte";
    import FormInput from "../../components/auth/FormInput.svelte";
    import { Button } from "$lib/components/ui/button";
    import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "$lib/components/ui/card";
    import { Alert } from "$lib/components/ui/alert";

    interface Props {
        mode?: 'forgot' | 'reset';
        token?: string;
        errors?: Record<string, string[]>;
        current_user?: any;
    }

    let { mode = 'forgot', token, errors = {}, current_user }: Props = $props();
</script>

<AuthLayout {current_user}>
    <Card class="w-full backdrop-blur-sm bg-card/80 border-border/40 shadow-xl">
        {#if mode === 'forgot'}
            <CardHeader class="text-center space-y-1">
                <CardTitle class="text-2xl font-bold tracking-tight text-foreground">Forgot your password?</CardTitle>
                <CardDescription class="text-muted-foreground">We'll send a password reset link to your inbox</CardDescription>
            </CardHeader>
            
            <CardContent>
                <form class="space-y-6" {...{"phx-submit": "send_email"}}>
                    <FormInput
                        label="Email address"
                        name="user[email]"
                        type="email"
                        required={true}
                        placeholder="Enter your email"
                        autocomplete="email"
                        error={errors.email?.[0]}
                    />

                    <Button 
                        type="submit"
                        class="w-full"
                        size="lg"
                        {...{"phx-disable-with": "Sending..."}}
                    >
                        Send reset instructions
                        <span aria-hidden="true" class="ml-2">→</span>
                    </Button>
                </form>
            </CardContent>
        {:else}
            <CardHeader class="text-center space-y-1">
                <CardTitle class="text-2xl font-bold tracking-tight text-foreground">Reset your password</CardTitle>
                <CardDescription class="text-muted-foreground">Enter your new password below</CardDescription>
            </CardHeader>
            
            <CardContent>
                <form class="space-y-6" {...{"phx-submit": "reset_password"}}>
                    {#if errors.form && errors.form.length > 0}
                        <Alert variant="destructive">
                            <div class="text-sm">
                                Oops, something went wrong! Please check the errors below.
                            </div>
                        </Alert>
                    {/if}

                    <div class="space-y-4">
                        <FormInput
                            label="New password"
                            name="user[password]"
                            type="password"
                            required={true}
                            placeholder="Minimum 12 characters"
                            error={errors.password?.[0]}
                        />
                        
                        <FormInput
                            label="Confirm new password"
                            name="user[password_confirmation]"
                            type="password"
                            required={true}
                            error={errors.password_confirmation?.[0]}
                        />
                    </div>

                    <Button 
                        type="submit"
                        class="w-full"
                        size="lg"
                        {...{"phx-disable-with": "Resetting..."}}
                    >
                        Reset password
                        <span aria-hidden="true" class="ml-2">→</span>
                    </Button>
                </form>
            </CardContent>
        {/if}
        
        <CardContent class="pt-0">
            <div class="text-center text-sm">
                <a href="/auth/login" class="font-medium text-primary hover:text-primary/80 transition-colors">Sign in</a>
                <span class="mx-2 text-muted-foreground">|</span>
                <a href="/auth/register" class="font-medium text-primary hover:text-primary/80 transition-colors">Create account</a>
            </div>
        </CardContent>
    </Card>
</AuthLayout>
