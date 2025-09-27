<script lang="ts">
    import AuthLayout from "../../components/auth/AuthLayout.svelte";
    import FormInput from "../../components/auth/FormInput.svelte";

    interface Props {
        errors?: Record<string, string[]>;
        checkErrors?: boolean;
        trigger_submit?: boolean;
    }

    let { errors = {}, checkErrors = false, trigger_submit = false }: Props = $props();

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

<AuthLayout>
    <div class="mx-auto max-w-sm">
        <div class="text-center mb-8">
            <h1 class="text-2xl font-bold tracking-tight text-gray-900">Create your account</h1>
            <p class="mt-2 text-sm text-gray-600">Join us today! Fill out the form below to get started.</p>
        </div>

        <!-- Use standard Phoenix form with phx-submit -->
        <form phx-submit="save" class="space-y-6">
            {#if checkErrors}
                <div class="rounded-md bg-red-50 p-4">
                    <div class="text-sm text-red-800">
                        Oops, something went wrong! Please check the errors below.
                    </div>
                </div>
            {/if}
            
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

            <button 
                type="submit"
                phx-disable-with="Creating account..."
                class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50 disabled:cursor-not-allowed"
            >
                Create account
                <span aria-hidden="true" class="ml-2">→</span>
            </button>
        </form>

        <div class="mt-6 text-center text-sm">
            <a href="/auth/login" class="font-medium text-indigo-600 hover:text-indigo-500">
                Already have an account? Sign in
            </a>
        </div>
    </div>
</AuthLayout>
