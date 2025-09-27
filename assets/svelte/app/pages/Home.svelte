<script lang="ts">
    import Navbar from "../components/Navbar.svelte";
    import Hero from "../sections/home/Hero.svelte";
    import Features from "../sections/home/Features.svelte";
    import Pricing from "../sections/home/Pricing.svelte";
    import CTA from "../sections/home/CTA.svelte";
    import Footer from "../sections/home/Footer.svelte";
    import type { LiveSocket } from "phoenix_live_view";
    import type { User } from "$lib/model/User";

    interface Props {
        socket: typeof LiveSocket;
        current_user?: User;
    }

    let { socket, current_user }: Props = $props();
</script>

<Navbar current_user={current_user} />
<Hero />
<Features />
<Pricing />
<CTA />
<Footer />
