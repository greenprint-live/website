<script lang="ts">
    import type { User } from "$lib/model/User";
    import { Button } from "$lib/components/ui/button";

    interface Props {
        current_user?: User;
    }

    const { current_user }: Props = $props();
</script>

<nav class="bg-background/50 backdrop-blur-sm w-full fixed top-0 left-0 flex flex-row justify-between items-center p-4 z-50">
    <a href="/" aria-label="GreenPrint Logo">
        <img src="/images/full-logo.png" alt="GreenPrint Logo" class="h-10 transition-transform duration-200 hover:scale-110" />
    </a>

    {#if current_user}
        <Button>
            <a href="/dashboard" aria-label="Dashboard">
                Dashboard
            </a>
        </Button>
    {:else}
        <Button>
            <a href="/users/log_in" aria-label="Login">
                Log in
            </a>
        </Button>
    {/if}
</nav>