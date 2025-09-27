<script lang="ts">
    import AuthLayout from "../../components/auth/AuthLayout.svelte";
    import AuthForm from "../../components/auth/AuthForm.svelte";
    import FormInput from "../../components/auth/FormInput.svelte";
    import type { LiveSocket } from "phoenix_live_view";

    interface Props {
        socket: any;
        email?: string;
        errors?: Record<string, string[]>;
    }

    let { socket, email = "", errors = {} }: Props = $props();

    let isSubmitting = $state(false);

    function handleSubmit(formData: FormData) {
        isSubmitting = true;
        // Convert FormData to object for Phoenix
        const params = {
            user: {
                email: formData.get('email') as string,
                password: formData.get('password') as string,
                remember_me: formData.get('remember_me') === 'on' ? 'true' : 'false'
            }
        };
        
        // Send to Phoenix controller
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '/users/log_in';
        
        // Add CSRF token
        const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
        if (csrfToken) {
            const csrfInput = document.createElement('input');
            csrfInput.type = 'hidden';
            csrfInput.name = '_csrf_token';
            csrfInput.value = csrfToken;
            form.appendChild(csrfInput);
        }

        // Add form data
        Object.entries(params.user).forEach(([key, value]) => {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = `user[${key}]`;
            input.value = value;
            form.appendChild(input);
        });

        document.body.appendChild(form);
        form.submit();
    }

    const links = [
        { text: "Sign up for an account", href: "/auth/register" },
        { text: "Forgot your password?", href: "/auth/forgot-password" }
    ];
</script>

<AuthLayout>
    <AuthForm
        title="Sign in to your account"
        subtitle="Welcome back! Please sign in to continue."
        submitText="Sign in"
        {isSubmitting}
        showRememberMe={true}
        {links}
        onSubmit={handleSubmit}
    >
        {#snippet children()}
            <FormInput
                label="Email address"
                name="email"
                type="email"
                required={true}
                value={email}
                autocomplete="email"
                error={errors.email?.[0]}
            />
            <FormInput
                label="Password"
                name="password"
                type="password"
                required={true}
                autocomplete="current-password"
                error={errors.password?.[0]}
            />
        {/snippet}
    </AuthForm>
</AuthLayout>
