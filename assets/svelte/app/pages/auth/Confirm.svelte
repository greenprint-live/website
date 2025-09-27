<script lang="ts">
    import AuthLayout from "../../components/auth/AuthLayout.svelte";
    import type { LiveSocket } from "phoenix_live_view";

    interface Props {
        socket: any;
        mode?: 'confirm' | 'resend';
        token?: string;
    }

    let { socket, mode = 'confirm', token }: Props = $props();

    let isSubmitting = $state(false);


    const links = [
        { text: "Sign in", href: "/auth/login" },
        { text: "Create account", href: "/auth/register" }
    ];
</script>

<AuthLayout>
    <div class="text-center">
        {#if mode === 'confirm'}
            <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-green-100 mb-4">
                <svg class="h-6 w-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                </svg>
            </div>
            <h1 class="text-2xl font-bold text-gray-900 mb-4">Confirm Your Account</h1>
            <p class="text-gray-600 mb-8">Click the button below to confirm your account and complete registration.</p>
            
            <form phx-submit="confirm_account">
                <input type="hidden" name="user[token]" value={token || ''} />
                <button 
                    type="submit"
                    phx-disable-with="Confirming..."
                    class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                    Confirm my account
                </button>
            </form>
        {:else}
            <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-blue-100 mb-4">
                <svg class="h-6 w-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                </svg>
            </div>
            <h1 class="text-2xl font-bold text-gray-900 mb-4">No confirmation instructions received?</h1>
            <p class="text-gray-600 mb-8">We'll send a new confirmation link to your inbox</p>
            
            <form phx-submit="send_instructions" class="space-y-4">
                <div>
                    <input
                        type="email"
                        name="user[email]"
                        placeholder="Email"
                        required
                        class="appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                    />
                </div>
                
                <button 
                    type="submit"
                    phx-disable-with="Sending..."
                    class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50"
                >
                    Resend confirmation instructions
                </button>
            </form>
        {/if}

        <div class="mt-6 text-center text-sm">
            {#each links as link, index}
                <a href={link.href} class="font-medium text-indigo-600 hover:text-indigo-500">
                    {link.text}
                </a>
                {#if index < links.length - 1}
                    <span class="mx-2 text-gray-500">|</span>
                {/if}
            {/each}
        </div>
    </div>
</AuthLayout>
