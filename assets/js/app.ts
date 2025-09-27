import { createLiveJsonHooks } from "live_json";
import { getHooks } from "live_svelte";
import { Socket } from "phoenix";
import "phoenix_html";
import { LiveSocket } from "phoenix_live_view";
import topbar from "topbar";
import { RealtimeData } from "./hooks/realtime_data.js";

const componentModules = import.meta.glob("../svelte/**/*.svelte", { eager: true });
const Components = Object.fromEntries(
    Object.entries(componentModules).map(([path, module]) => {
        const name = path.replace("../svelte/", "").replace(".svelte", "");
        return [name, (module as any).default];
    })
);

const hooks = {
    ...createLiveJsonHooks(),
    ...getHooks(Components),
    RealtimeData
};

const csrfTokenTag = document.querySelector("meta[name='csrf-token']");
if (!csrfTokenTag) {
    throw new Error("Missing csrf-token meta tag");
}

let csrfToken = csrfTokenTag.getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, { hooks, params: { _csrf_token: csrfToken } });

topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
(window as any).liveSocket = liveSocket;
