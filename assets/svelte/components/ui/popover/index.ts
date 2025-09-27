import Content from "./popover-content.svelte";
import Trigger from "./popover-trigger.svelte";
import { Popover as PopoverPrimitive } from "bits-ui";

const Root = PopoverPrimitive.Root;
const Close = PopoverPrimitive.Close;

export {
    Root,
    Content,
    Trigger,
    Close,
    //
    Root as Popover,
    Content as PopoverContent,
    Trigger as PopoverTrigger,
    Close as PopoverClose
};
