import { defineConfig } from "@lovable.dev/vite-tanstack-config";
import { VitePWA } from "vite-plugin-pwa";

export default defineConfig({
  tanstackStart: {
    server: { entry: "server" },
  },
  vite: {
    server: {
      host: "0.0.0.0",
      port: 5173,
      strictPort: false,
    },
    preview: {
      host: "0.0.0.0",
      port: 4173,
      strictPort: false,
    },
    plugins: [
      VitePWA({
        registerType: "autoUpdate",
        injectRegister: "auto",
        includeAssets: ["icon-192.png", "icon-512.png"],
        workbox: {
          cleanupOutdatedCaches: true,
          clientsClaim: true,
          skipWaiting: true,
          navigateFallback: "/",
          globPatterns: ["**/*.{js,css,html,ico,png,svg,webp,woff2,json}"],
          runtimeCaching: [
            {
              urlPattern: ({ request }) => request.mode === "navigate",
              handler: "NetworkFirst",
              options: {
                cacheName: "spark-pages",
                networkTimeoutSeconds: 3,
                expiration: {
                  maxEntries: 50,
                  maxAgeSeconds: 60 * 60 * 24 * 30,
                },
              },
            },
            {
              urlPattern: ({ url }) =>
                url.pathname.startsWith("/assets/") ||
                url.pathname.startsWith("/icon-"),
              handler: "CacheFirst",
              options: {
                cacheName: "spark-assets",
                expiration: {
                  maxEntries: 100,
                  maxAgeSeconds: 60 * 60 * 24 * 365,
                },
              },
            },
            {
              urlPattern: ({ url }) => url.pathname.startsWith("/api/"),
              handler: "NetworkOnly",
            },
          ],
        },
        manifest: {
          id: "/",
          name: "Spark English Learning",
          short_name: "Spark",
          description: "English learning app for Mongolian students.",
          start_url: "/",
          scope: "/",
          display: "standalone",
          display_override: ["standalone", "minimal-ui"],
          orientation: "portrait",
          background_color: "#0f172a",
          theme_color: "#0f172a",
          categories: ["education", "productivity"],
          icons: [
            {
              src: "/icon-192.png",
              sizes: "192x192",
              type: "image/png",
              purpose: "any maskable",
            },
            {
              src: "/icon-512.png",
              sizes: "512x512",
              type: "image/png",
              purpose: "any maskable",
            },
          ],
          screenshots: [
            {
              src: "/icon-512.png",
              sizes: "512x512",
              type: "image/png",
              form_factor: "narrow",
            },
          ],
        },
        devOptions: {
          enabled: true,
          type: "module",
        },
      }),
    ],
  },
});
