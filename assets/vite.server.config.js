import { svelte } from "@sveltejs/vite-plugin-svelte";
import { defineConfig } from "vite";

export default defineConfig({
    plugins: [
        svelte({
            configFile: "./svelte.config.js"
        })
    ],
    build: {
        outDir: "../priv/svelte",
        emptyOutDir: false,
        ssr: true,
        rollupOptions: {
            input: "js/server.ts",
            output: {
                entryFileNames: "server.js",
                format: "cjs"
            }
        },
        sourcemap: process.env.NODE_ENV !== "production",
        minify: false,
        target: "node22.17.0"
    },
    resolve: {
        alias: {
            $lib: "/Users/dec/programming/projects/greenprint/website/assets/svelte"
        }
    },
    define: {
        "process.env.NODE_ENV": JSON.stringify(process.env.NODE_ENV || "development")
    }
});
