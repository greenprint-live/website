<script lang="ts">
    import FormInput from "../../components/auth/FormInput.svelte";
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

<div class="max-w-2xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
    <div class="text-center mb-8">
        <h1 class="text-3xl font-bold text-gray-900">Account Settings</h1>
        <p class="mt-2 text-sm text-gray-600">Manage your account email address and password settings</p>
    </div>

    <div class="space-y-12 divide-y divide-gray-200">
        <!-- Email Settings -->
        <div class="pt-8 first:pt-0">
            <h2 class="text-lg font-medium text-gray-900 mb-4">Email Address</h2>
            <form phx-submit="update_email" class="space-y-4">
                
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

                <button 
                    type="submit"
                    phx-disable-with="Changing..."
                    class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50"
                >
                    Change Email
                </button>
            </form>
        </div>

        <!-- Password Settings -->
        <div class="pt-8">
            <h2 class="text-lg font-medium text-gray-900 mb-4">Password</h2>
            <form phx-submit="update_password" class="space-y-4">
                
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

                <button 
                    type="submit"
                    phx-disable-with="Changing..."
                    class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50"
                >
                    Change Password
                </button>
            </form>
        </div>

        <!-- Account Actions -->
        <div class="pt-8">
            <h2 class="text-lg font-medium text-gray-900 mb-4">Account Actions</h2>
            <div class="flex flex-col sm:flex-row gap-4">
                <button 
                    onclick={handleLogout}
                    class="inline-flex justify-center py-2 px-4 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                >
                    Log Out
                </button>
            </div>
        </div>
    </div>
</div>
