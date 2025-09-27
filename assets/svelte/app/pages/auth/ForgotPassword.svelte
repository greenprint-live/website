<script lang="ts">
    import AuthLayout from "../../components/auth/AuthLayout.svelte";
    import FormInput from "../../components/auth/FormInput.svelte";

    interface Props {
        mode?: 'forgot' | 'reset';
        token?: string;
        errors?: Record<string, string[]>;
    }

    let { mode = 'forgot', token, errors = {} }: Props = $props();
</script>

<AuthLayout>
    <div class="mx-auto max-w-sm">
        {#if mode === 'forgot'}
            <div class="text-center mb-8">
                <h1 class="text-2xl font-bold tracking-tight text-gray-900">Forgot your password?</h1>
                <p class="mt-2 text-sm text-gray-600">We'll send a password reset link to your inbox</p>
            </div>

            <form phx-submit="send_email" class="space-y-6">
                <FormInput
                    label="Email address"
                    name="user[email]"
                    type="email"
                    required={true}
                    placeholder="Enter your email"
                    autocomplete="email"
                    error={errors.email?.[0]}
                />

                <button 
                    type="submit"
                    phx-disable-with="Sending..."
                    class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                >
                    Send reset instructions
                    <span aria-hidden="true" class="ml-2">→</span>
                </button>
            </form>
        {:else}
            <div class="text-center mb-8">
                <h1 class="text-2xl font-bold tracking-tight text-gray-900">Reset your password</h1>
                <p class="mt-2 text-sm text-gray-600">Enter your new password below</p>
            </div>

            <form phx-submit="reset_password" class="space-y-6">
                {#if errors.form && errors.form.length > 0}
                    <div class="rounded-md bg-red-50 p-4">
                        <div class="text-sm text-red-800">
                            Oops, something went wrong! Please check the errors below.
                        </div>
                    </div>
                {/if}

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

                <button 
                    type="submit"
                    phx-disable-with="Resetting..."
                    class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                >
                    Reset password
                    <span aria-hidden="true" class="ml-2">→</span>
                </button>
            </form>
        {/if}

        <div class="mt-6 text-center text-sm">
            <a href="/auth/login" class="font-medium text-indigo-600 hover:text-indigo-500">Sign in</a>
            <span class="mx-2 text-gray-500">|</span>
            <a href="/auth/register" class="font-medium text-indigo-600 hover:text-indigo-500">Create account</a>
        </div>
    </div>
</AuthLayout>
