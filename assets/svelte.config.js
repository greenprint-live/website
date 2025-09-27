import { sveltePreprocess } from "svelte-preprocess";

const config = {
    preprocess: sveltePreprocess({
        typescript: true
    }),
    compilerOptions: {
        dev: process.env.NODE_ENV !== "production",
        css: "injected"
    }
};

export default config;
