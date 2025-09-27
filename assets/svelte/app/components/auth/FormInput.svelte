<script lang="ts">
    import { Input } from "$lib/components/ui/input";
    import { Label } from "$lib/components/ui/label";
    
    interface Props {
        label: string;
        name: string;
        type?: string;
        required?: boolean;
        placeholder?: string;
        value?: string;
        error?: string;
        autocomplete?: string;
    }

    let {
        label,
        name,
        type = "text",
        required = false,
        placeholder,
        value = "",
        error,
        autocomplete
    }: Props = $props();

    let inputId = `input-${name}`;
</script>

<div class="space-y-2">
    <Label for={inputId} class="text-foreground font-medium">
        {label}
        {#if required}
            <span class="text-destructive">*</span>
        {/if}
    </Label>
    <Input
        {type}
        {name}
        id={inputId}
        {required}
        {placeholder}
        {value}
        autocomplete={autocomplete as any}
        class={error ? "border-destructive focus-visible:ring-destructive/20" : "border-border/40 hover:border-border/60"}
        aria-invalid={error ? "true" : "false"}
        aria-describedby={error ? `${inputId}-error` : undefined}
    />
    {#if error}
        <p id="{inputId}-error" class="text-sm text-destructive">{error}</p>
    {/if}
</div>