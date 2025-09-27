<script lang="ts">
    import type { User } from "$lib/model/User";
    import { Button } from "$lib/components/ui/button";
    import clsx from "clsx";

    interface Props {
        current_user?: User;
        fixed?: boolean;
    }

    const { current_user, fixed }: Props = $props();
</script>

<nav class={clsx(
    "bg-background/50 backdrop-blur-sm w-full top-0 left-0 flex flex-row justify-between items-center p-4 z-50",
    { "fixed": fixed }
)}>
    <a href="/" aria-label="GreenPrint Logo">
        <img src="/images/full-logo.png" alt="GreenPrint Logo" class="h-10 transition-transform duration-200 hover:scale-110" />
    </a>

    {#if current_user}
        <div class="flex flex-row items-center gap-2">
            <a href="/dashboard" aria-label="Dashboard">
                <Button>Dashboard</Button>
            </a>

            <a href="/auth/settings" aria-label="Account">
                <Button>Account</Button>
            </a>
        </div>
    {:else}
        <a href="/auth/login" aria-label="Login">
            <Button>Log in</Button>
        </a>
    {/if}
</nav>