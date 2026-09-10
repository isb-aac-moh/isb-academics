import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'
import { VitePWA } from 'vite-plugin-pwa'

export default defineConfig({
  plugins: [
    react(),
    tailwindcss(),
    VitePWA({
      registerType: 'autoUpdate',
      includeAssets: ['favicon.png'],
      manifest: {
        name: 'ISB Academics',
        short_name: 'ISB Academics',
        description: 'Course planning, bidding, and credit tracking for ISB PGP students.',
        theme_color: '#F4F2EC',
        background_color: '#F4F2EC',
        display: 'standalone',
        start_url: '/',
        icons: [
          { src: '/icon-192.png', sizes: '192x192', type: 'image/png' },
          { src: '/icon-512.png', sizes: '512x512', type: 'image/png' },
          { src: '/icon-512.png', sizes: '512x512', type: 'image/png', purpose: 'maskable' },
        ],
      },
    }),
  ],
  // Pinned to match the localhost redirect URL Supabase Auth is allow-listed
  // for (see docs/ARCHITECTURE.md) — silently falling back to another port
  // makes OAuth login bounce to isb-explorer's production URL instead.
  server: { port: 5174, strictPort: true },
  build: {
    // Left to itself the bundler folds React and supabase-js into the entry chunk on some builds
    // and splits them on others, so a one-line app change can invalidate 450 kB of cached vendor
    // code. Pinning the two groups keeps them in their own long-lived files: neither changes
    // unless its dependency is upgraded.
    rollupOptions: {
      output: {
        codeSplitting: {
          groups: [
            { name: 'react-vendor', test: /node_modules[\\/](react|react-dom|react-router|react-router-dom|scheduler)[\\/]/ },
            { name: 'supabase-vendor', test: /node_modules[\\/]@supabase[\\/]/ },
          ],
        },
      },
    },
  },
})
