<script lang="ts">
    import Navbar from "../Navbar.svelte";
    
    interface Props {
        children: any;
        current_user?: any;
    }

    let { children, current_user }: Props = $props();
</script>

<div class="min-h-screen bg-background">
    <Navbar {current_user} />
    
    <section class="bg-background min-h-screen flex items-center justify-center px-4 sm:px-6 lg:px-8 pt-16">
        <div class="max-w-md w-full">
            {@render children()}
        </div>
    </section>
</div>