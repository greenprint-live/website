<script lang="ts">
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

<div>
    <label for={inputId} class="block text-sm font-medium text-gray-700">
        {label}
        {#if required}
            <span class="text-red-500">*</span>
        {/if}
    </label>
    <div class="mt-1">
        <input
            {type}
            {name}
            id={inputId}
            {required}
            {placeholder}
            {value}
            autocomplete={autocomplete}
            class="appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
            class:border-red-300={error}
            class:text-red-900={error}
            class:placeholder-red-300={error}
            class:focus:ring-red-500={error}
            class:focus:border-red-500={error}
        />
    </div>
    {#if error}
        <p class="mt-2 text-sm text-red-600">{error}</p>
    {/if}
</div>