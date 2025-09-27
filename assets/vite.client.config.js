import { svelte } from "@sveltejs/vite-plugin-svelte";
import { defineConfig } from "vite";

export default defineConfig({
    plugins: [
        svelte({
            configFile: "./svelte.config.js"
        })
    ],
    build: {
        outDir: "../priv/static/assets",
        emptyOutDir: false,
        rollupOptions: {
            input: "js/app.ts",
            output: {
                entryFileNames: "app.js",
                chunkFileNames: "[name]-[hash].js",
                assetFileNames: "[name]-[hash].[ext]"
            }
        },
        sourcemap: process.env.NODE_ENV !== "production",
        minify: process.env.NODE_ENV === "production"
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
