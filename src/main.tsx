import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { BrowserRouter } from "react-router-dom";
import { Analytics } from "@vercel/analytics/react";
import { SpeedInsights } from "@vercel/speed-insights/react";
import "./index.css";
import App from "./App.tsx";

import posthog from "posthog-js";
import { PostHogProvider, PostHogErrorBoundary } from "@posthog/react";
import { registerSW } from "virtual:pwa-register";

const phToken = import.meta.env.VITE_PUBLIC_POSTHOG_PROJECT_TOKEN as string | undefined;
const phHost = import.meta.env.VITE_PUBLIC_POSTHOG_HOST as string | undefined;

if (!phToken) {
  if (import.meta.env.DEV) {
    throw new Error(
      "VITE_PUBLIC_POSTHOG_PROJECT_TOKEN variable required by PostHog is missing or un-configured, " +
      "this causes events to be silently missed. This error stops appearing once VITE_PUBLIC_POSTHOG_PROJECT_TOKEN is configured"
    );
  }
} else {
  posthog.init(phToken, {
    api_host: phHost ?? "https://us.i.posthog.com",
    defaults: "2026-01-30",
  });
}

// Some browsers refuse to install a service worker (for example when the user
// blocks site data). That refusal is expected and only disables offline caching,
// so we log it instead of letting it surface as an unhandled rejection.
registerSW({
  onRegisterError(error) {
    console.warn("Service worker registration failed:", error);
  },
});

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <PostHogProvider client={posthog}>
      <PostHogErrorBoundary>
        <BrowserRouter>
          <App />
          <Analytics />
          <SpeedInsights />
        </BrowserRouter>
      </PostHogErrorBoundary>
    </PostHogProvider>
  </StrictMode>
);
