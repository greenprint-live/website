import { spawn } from "child_process";

const args = process.argv.slice(2);
const watch = args.includes("--watch");
const deploy = args.includes("--deploy");

if (deploy) {
    process.env.NODE_ENV = "production";
}

/**
 * @param {string} command
 * @param {string[]} args
 * @param {Object} options
 * @returns {Promise<void>}
 */
function runCommand(command, args, options = {}) {
    return new Promise((resolve, reject) => {
        const child = spawn(command, args, {
            stdio: "inherit",
            ...options
        });

        child.on("close", (code) => {
            if (code === 0) {
                resolve();
            } else {
                reject(new Error(`Command failed with code ${code}`));
            }
        });

        child.on("error", reject);
    });
}

/**
 * @returns {Promise<void>}
 */
async function buildAll() {
    if (watch) {
        console.log("Starting Vite in watch mode...");

        try {
            const clientWatch = runCommand("npx", ["vite", "build", "--config", "vite.client.config.js", "--watch"]);
            const serverWatch = runCommand("npx", ["vite", "build", "--config", "vite.server.config.js", "--watch"]);

            await Promise.all([clientWatch, serverWatch]);
        } catch (error) {
            console.error("Watch mode failed:", error);
            process.exit(1);
        }
    } else {
        try {
            console.log("Building client for production...");
            await runCommand("npx", ["vite", "build", "--config", "vite.client.config.js"]);
            console.log("Client build completed");

            console.log("Building server for production...");
            await runCommand("npx", ["vite", "build", "--config", "vite.server.config.js"]);
            console.log("Server build completed");
        } catch (error) {
            console.error("Build failed:", error);
            process.exit(1);
        }
    }
}

buildAll();
