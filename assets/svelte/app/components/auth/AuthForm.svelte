<script lang="ts">
    interface Props {
        title: string;
        subtitle?: string;
        submitText: string;
        isSubmitting?: boolean;
        showRememberMe?: boolean;
        children: any;
        links?: Array<{text: string, href: string}>;
        onSubmit: (data: FormData) => void;
    }

    let { 
        title, 
        subtitle, 
        submitText, 
        isSubmitting = false,
        showRememberMe = false,
        children,
        links = [],
        onSubmit 
    }: Props = $props();

    let formElement: HTMLFormElement;

    function handleSubmit(event: Event) {
        event.preventDefault();
        const formData = new FormData(formElement);
        onSubmit(formData);
    }
</script>

<div class="mx-auto max-w-sm">
    <div class="text-center mb-8">
        <h1 class="text-2xl font-bold tracking-tight text-gray-900">{title}</h1>
        {#if subtitle}
            <p class="mt-2 text-sm text-gray-600">{subtitle}</p>
        {/if}
    </div>

    <form bind:this={formElement} onsubmit={handleSubmit} class="space-y-6">
        {@render children()}
        
        {#if showRememberMe}
            <div class="flex items-center justify-between">
                <div class="flex items-center">
                    <input 
                        id="remember_me" 
                        name="remember_me" 
                        type="checkbox" 
                        class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
                    />
                    <label for="remember_me" class="ml-2 block text-sm text-gray-900">
                        Keep me logged in
                    </label>
                </div>
            </div>
        {/if}

        <button 
            type="submit"
            disabled={isSubmitting}
            class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50 disabled:cursor-not-allowed"
        >
            {#if isSubmitting}
                <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                Processing...
            {:else}
                {submitText}
                <span aria-hidden="true" class="ml-2">→</span>
            {/if}
        </button>
    </form>

    {#if links.length > 0}
        <div class="mt-6 text-center text-sm">
            {#each links as link, index}
                <a href={link.href} class="font-medium text-indigo-600 hover:text-indigo-500">
                    {link.text}
                </a>
                {#if index < links.length - 1}
                    <span class="mx-2 text-gray-500">|</span>
                {/if}
            {/each}
        </div>
    {/if}
</div>