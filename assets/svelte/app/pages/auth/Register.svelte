<script lang="ts">
    import AuthLayout from "../../components/auth/AuthLayout.svelte";
    import FormInput from "../../components/auth/FormInput.svelte";
    import { Button } from "$lib/components/ui/button";
    import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "$lib/components/ui/card";
    import { Alert } from "$lib/components/ui/alert";

    interface Props {
        errors?: Record<string, string[]>;
        checkErrors?: boolean;
        trigger_submit?: boolean;
        current_user?: any;
    }

    let { errors = {}, checkErrors = false, trigger_submit = false, current_user }: Props = $props();

    // Auto-login after successful registration
    $effect(() => {
        if (trigger_submit) {
            // Auto-submit to login
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '/users/log_in?_action=registered';
            
            // Add CSRF token
            const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
            if (csrfToken) {
                const csrfInput = document.createElement('input');
                csrfInput.type = 'hidden';
                csrfInput.name = '_csrf_token';
                csrfInput.value = csrfToken;
                form.appendChild(csrfInput);
            }

            // Get the form data from the page
            const emailInput = document.querySelector('input[name="user[email]"]') as HTMLInputElement;
            const passwordInput = document.querySelector('input[name="user[password]"]') as HTMLInputElement;

            if (emailInput && passwordInput) {
                ['email', 'password'].forEach(field => {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = `user[${field}]`;
                    input.value = field === 'email' ? emailInput.value : passwordInput.value;
                    form.appendChild(input);
                });

                document.body.appendChild(form);
                form.submit();
            }
        }
    });
</script>

<AuthLayout {current_user}>
    <Card class="w-full backdrop-blur-sm bg-card/80 border-border/40 shadow-xl">
        <CardHeader class="text-center space-y-1">
            <CardTitle class="text-2xl font-bold tracking-tight text-foreground">Create your account</CardTitle>
            <CardDescription class="text-muted-foreground">Join us today! Fill out the form below to get started.</CardDescription>
        </CardHeader>
        
        <CardContent>
            <!-- Use standard Phoenix form with phx-submit -->
            <form class="space-y-6" {...{"phx-submit": "save"}}>
                {#if checkErrors}
                    <Alert variant="destructive">
                        <div class="text-sm">
                            Oops, something went wrong! Please check the errors below.
                        </div>
                    </Alert>
                {/if}
                
                <div class="space-y-4">
                    <FormInput
                        label="Email address"
                        name="user[email]"
                        type="email"
                        required={true}
                        autocomplete="email"
                        error={errors.email?.[0]}
                    />
                    <FormInput
                        label="Password"
                        name="user[password]"
                        type="password"
                        required={true}
                        autocomplete="new-password"
                        placeholder="Minimum 12 characters"
                        error={errors.password?.[0]}
                    />
                </div>

                <Button 
                    type="submit"
                    class="w-full"
                    size="lg"
                    {...{"phx-disable-with": "Creating account..."}}
                >
                    Create account
                    <span aria-hidden="true" class="ml-2">→</span>
                </Button>
            </form>

            <div class="mt-6 text-center text-sm">
                <a href="/auth/login" class="font-medium text-primary hover:text-primary/80 transition-colors">
                    Already have an account? Sign in
                </a>
            </div>
        </CardContent>
    </Card>
</AuthLayout>
