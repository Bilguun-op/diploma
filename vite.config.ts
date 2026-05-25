// @lovable.dev/vite-tanstack-config already includes the following — do NOT add them manually
// or the app will break with duplicate plugins:
//   - tanstackStart, viteReact, tailwindcss, tsConfigPaths, cloudflare (build-only),
//     componentTagger (dev-only), VITE_* env injection, @ path alias, React/TanStack dedupe,
//     error logger plugins, and sandbox detection (port/host/strictPort).

import { defineConfig } from "@lovable.dev/vite-tanstack-config";
import { VitePWA } from "vite-plugin-pwa";

export default defineConfig({
  tanstackStart: {
    server: { entry: "server" },
  },

  vite: {
    plugins: [
      VitePWA({
        registerType: "autoUpdate",
        includeAssets: ["favicon.ico"],
        manifest: {
          name: "Spark English Learning",
          short_name: "Spark",
          start_url: "/",
          display: "standalone",
          background_color: "#0f172a",
          theme_color: "#0f172a",
          icons: [
            {
              src: "/icon-192.png",
              sizes: "192x192",
              type: "image/png"
            },
            {
              src: "/icon-512.png",
              sizes: "512x512",
              type: "image/png"
            }
          ]
        }
      })
    ]
  }
});