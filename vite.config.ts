import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [react(), tailwindcss()],
  // Pinned to match the localhost redirect URL Supabase Auth is allow-listed
  // for (see docs/ARCHITECTURE.md) — silently falling back to another port
  // makes OAuth login bounce to isb-explorer's production URL instead.
  server: { port: 5174, strictPort: true },
})
