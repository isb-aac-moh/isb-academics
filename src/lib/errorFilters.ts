import type { CaptureResult } from "posthog-js";

// Link-scanning crawlers (notably Microsoft Outlook SafeLinks, which drives a
// headless CefSharp browser) and some browser extensions inject a script that
// rejects a promise with a plain string such as:
//   "Object Not Found Matching Id:3, MethodName:update, ParamCount:4"
// PostHog records this as an UnhandledRejection with no application stack frame.
// The page keeps working for real users, so this is third-party noise, not an
// app fault. Drop it before it reaches error tracking.
const CRAWLER_REJECTION_SIGNATURE = "Object Not Found Matching Id";

function isCrawlerRejection(event: CaptureResult): boolean {
  if (event.event !== "$exception") return false;
  const exceptions = event.properties?.$exception_list;
  if (!Array.isArray(exceptions)) return false;
  return exceptions.some(
    (exception) =>
      typeof exception?.value === "string" &&
      exception.value.includes(CRAWLER_REJECTION_SIGNATURE)
  );
}

export function dropKnownNoiseExceptions(
  event: CaptureResult | null
): CaptureResult | null {
  if (event && isCrawlerRejection(event)) return null;
  return event;
}
