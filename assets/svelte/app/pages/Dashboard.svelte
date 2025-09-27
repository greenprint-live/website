<script lang="ts">
    import type { User } from "$lib/model/User";
    import type { GPHub } from "$lib/model/Data";
    import type { LiveSocket } from "phoenix_live_view";
    import Navbar from "../components/Navbar.svelte";
    import HubCard from "../components/dashboard/HubCard.svelte";
    import { Card, CardHeader, CardTitle, CardContent } from "$lib/components/ui/card";
    import { Button } from "$lib/components/ui/button";

    interface Props {
        socket: typeof LiveSocket;
        current_user: User;
        hubs: GPHub[];
    }

    let { socket, current_user, hubs }: Props = $props();
</script>

<Navbar current_user={current_user} />

<div class="grid grid-cols-1 gap-4 grid-flow-row md:grid-cols-2 lg:grid-cols-3">
    {#each hubs as hub}
        <HubCard hub={hub} />
    {/each}

    <Card>
        <CardHeader>
            <CardTitle>Add Hub</CardTitle>
        </CardHeader>
        <CardContent>
            <Button>Add Hub</Button>
        </CardContent>
    </Card>
</div>
