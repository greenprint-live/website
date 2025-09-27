<script lang="ts">
	import type { Live } from "live_svelte";
    import { Button, buttonVariants } from "$lib/components/ui/button/index.js";
    import * as Dialog from "$lib/components/ui/dialog/index.js";
    import { Input } from "$lib/components/ui/input/index.js";
    import { Label } from "$lib/components/ui/label/index.js";

    let { number, live }: { number: number, live: Live } = $props();

    let customCount = $state(number);

    function increase() {
        live.pushEvent("set_number", {number: number + 1}, () => {})
        customCount += 1;
    }

    function decrease() {
        live.pushEvent("set_number", {number: number - 1}, () => {})
        customCount -= 1;
    }

    let fullString = $derived(`Server: ${number} | Custom: ${customCount}`);
</script>

<p class="text-red-500">The number is {fullString}</p>
<button onclick={increase}>+</button>
<button onclick={decrease}>-</button>
    
<Dialog.Root>
<Dialog.Trigger class={buttonVariants({ variant: "outline" })}
    >Edit Profile</Dialog.Trigger
>
<Dialog.Content class="sm:max-w-[425px]">
    <Dialog.Header>
    <Dialog.Title>Edit profile</Dialog.Title>
    <Dialog.Description>
    Make changes to your profile here. Click save when you're done.
    </Dialog.Description>
    </Dialog.Header>
    <div class="grid gap-4 py-4">
    <div class="grid grid-cols-4 items-center gap-4">
    <Label for="name" class="text-right">Name</Label>
    <Input id="name" value="Pedro Duarte" class="col-span-3" />
    </div>
    <div class="grid grid-cols-4 items-center gap-4">
    <Label for="username" class="text-right">Username</Label>
    <Input id="username" value="@peduarte" class="col-span-3" />
    </div>
    </div>
    <Dialog.Footer>
    <Button type="submit">Save changes</Button>
    </Dialog.Footer>
</Dialog.Content>
</Dialog.Root>