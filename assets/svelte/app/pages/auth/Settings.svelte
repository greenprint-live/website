<script lang="ts">
    import FormInput from "../../components/auth/FormInput.svelte";
    import Navbar from "../../components/Navbar.svelte";
    import { Button } from "$lib/components/ui/button";
    import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "$lib/components/ui/card";
    import type { LiveSocket } from "phoenix_live_view";
    import type { User } from "$lib/model/User";

    interface Props {
        socket: any;
        current_user: User;
        emailErrors?: Record<string, string[]>;
        passwordErrors?: Record<string, string[]>;
    }

    let { socket, current_user, emailErrors = {}, passwordErrors = {} }: Props = $props();

    let isUpdatingEmail = $state(false);
    let isUpdatingPassword = $state(false);

    function handleLogout() {
        // Create a form to submit the logout request
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '/users/log_out';
        
        // Add CSRF token
        const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
        if (csrfToken) {
            const csrfInput = document.createElement('input');
            csrfInput.type = 'hidden';
            csrfInput.name = '_csrf_token';
            csrfInput.value = csrfToken;
            form.appendChild(csrfInput);
        }

        // Add method override for DELETE
        const methodInput = document.createElement('input');
        methodInput.type = 'hidden';
        methodInput.name = '_method';
        methodInput.value = 'delete';
        form.appendChild(methodInput);

        document.body.appendChild(form);
        form.submit();
    }

</script>

<div class="min-h-screen bg-background">
    <Navbar {current_user} />
    
    <div class="pt-16">
        <section class="py-12 px-4 sm:px-6 lg:px-8">
            <div class="max-w-2xl mx-auto">
                <div class="text-center mb-8">
                    <h1 class="text-3xl font-bold text-foreground">Account Settings</h1>
                    <p class="mt-2 text-sm text-muted-foreground">Manage your account email address and password settings</p>
                </div>

                <div class="space-y-6">
                    <!-- Email Settings -->
                    <Card class="backdrop-blur-sm bg-card/80 border-border/40">
                        <CardHeader>
                            <CardTitle class="text-lg">Email Address</CardTitle>
                            <CardDescription>Update your email address and confirm with your current password</CardDescription>
                        </CardHeader>
                        <CardContent>
                            <form class="space-y-4" {...{"phx-submit": "update_email"}}>
                                <FormInput
                                    label="Email"
                                    name="email"
                                    type="email"
                                    required={true}
                                    value={current_user.email}
                                    error={emailErrors.email?.[0]}
                                />
                                
                                <FormInput
                                    label="Current password"
                                    name="current_password"
                                    type="password"
                                    required={true}
                                    error={emailErrors.current_password?.[0]}
                                />

                                <Button 
                                    type="submit"
                                    class="w-full sm:w-auto"
                                    {...{"phx-disable-with": "Changing..."}}
                                >
                                    Change Email
                                </Button>
                            </form>
                        </CardContent>
                    </Card>

                    <!-- Password Settings -->
                    <Card class="backdrop-blur-sm bg-card/80 border-border/40">
                        <CardHeader>
                            <CardTitle class="text-lg">Password</CardTitle>
                            <CardDescription>Update your password to keep your account secure</CardDescription>
                        </CardHeader>
                        <CardContent>
                            <form class="space-y-4" {...{"phx-submit": "update_password"}}>
                                <FormInput
                                    label="New password"
                                    name="password"
                                    type="password"
                                    required={true}
                                    placeholder="Minimum 12 characters"
                                    error={passwordErrors.password?.[0]}
                                />
                                
                                <FormInput
                                    label="Confirm new password"
                                    name="password_confirmation"
                                    type="password"
                                    required={true}
                                    error={passwordErrors.password_confirmation?.[0]}
                                />
                                
                                <FormInput
                                    label="Current password"
                                    name="current_password_for_password"
                                    type="password"
                                    required={true}
                                    error={passwordErrors.current_password?.[0]}
                                />

                                <Button 
                                    type="submit"
                                    class="w-full sm:w-auto"
                                    {...{"phx-disable-with": "Changing..."}}
                                >
                                    Change Password
                                </Button>
                            </form>
                        </CardContent>
                    </Card>

                    <!-- Account Actions -->
                    <Card class="backdrop-blur-sm bg-card/80 border-border/40">
                        <CardHeader>
                            <CardTitle class="text-lg">Account Actions</CardTitle>
                            <CardDescription>Manage your account and sign out</CardDescription>
                        </CardHeader>
                        <CardContent>
                            <Button 
                                onclick={handleLogout}
                                class="w-full sm:w-auto"
                            >
                                Log Out
                            </Button>
                        </CardContent>
                    </Card>
                </div>
            </div>
        </section>
    </div>
</div>
