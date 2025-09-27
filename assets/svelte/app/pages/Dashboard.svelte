<script lang="ts">
    import type { User } from "$lib/model/User";
    import type { LiveSocket } from "phoenix_live_view";
    import Navbar from "../components/Navbar.svelte";

    interface Props {
        socket: typeof LiveSocket;
        current_user?: User;
    }

    let { socket, current_user }: Props = $props();
</script>

<Navbar current_user={current_user} />