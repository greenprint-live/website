import { getRender } from "live_svelte";

const componentModules = import.meta.glob("../svelte/**/*.svelte", { eager: true });
const Components = Object.fromEntries(
    Object.entries(componentModules).map(([path, module]) => {
        const name = path.replace("../svelte/", "").replace(".svelte", "");
        return [name, (module as any).default];
    })
);

export const render = getRender(Components);
