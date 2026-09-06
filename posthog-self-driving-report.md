# PostHog Self-driving setup report

## Summary

PostHog Self-driving is configured with Session Replay and Error Tracking already enabled, Support enabled during this run, and the relevant native signal sources turned on. The targeted scout troop is active; its first scans should be picked up within about 30 minutes and findings will appear in the [Self-driving inbox](https://us.posthog.com/project/596443/inbox).

## AI data processing

Approved by the wizard's organization-level gate.

## GitHub

GitHub was already connected before this setup. No GitHub Issues responder was enabled because no additional connected tool was selected.

## Products enabled

| Product | Result | Web SDK check |
|---|---|---|
| Session Replay | Already enabled | `src/main.tsx` does not disable session recording. |
| Error Tracking | Already enabled | `src/main.tsx` does not disable exception capture. |
| Support / Conversations | Enabled during this run | Connect an inbound email, inbox, or Slack channel before support tickets can arrive. |

## Signal sources

| Source product | Source type | Result |
|---|---|---|
| `signals_scout` | `cross_source_issue` | Enabled by default; no opt-out configuration row was created. |
| `health_checks` | `health_issue` | Enabled (source config `01a0773f-2e9a-709c-9f13-c7bbac32d998`). |
| `error_tracking` | `issue_created` | Enabled (source config `01a0773f-2e47-7a21-b018-93bacca78053`). |
| `error_tracking` | `issue_reopened` | Enabled (source config `01a0773f-2dc9-7b34-88d6-263e3ef2a329`). |
| `error_tracking` | `issue_spiking` | Enabled (source config `01a0773f-2dce-7084-9d2c-4a6314eef194`). |
| `conversations` | `ticket` | Enabled (source config `01a0773f-2df5-710f-a1ea-12c3c8d34e55`). |
| Session replay source row | Retired / not created | Replay coverage belongs to Replay Vision scanners, not a `session_replay` signal-source row. |

## Connected tools

No external connected tools were selected in the setup prompt, so no external responders were enabled. GitHub remains connected for Self-driving research and implementation work.

## Scout troop

Three of 27 built-in scouts are active, all on the server default daily cadence and emitting to the inbox:

| Active scout | What it watches |
|---|---|
| `signals-scout-general` | Cross-product relationships and uncovered general surfaces. |
| `signals-scout-product-analytics` | Product-flow regressions across the academic planning experience. |
| `signals-scout-web-analytics` | Traffic, attribution, and landing-page health for the browser app. |

The other 24 scouts remain disabled to keep the troop selective. Product-specific scouts for revenue, AI observability, surveys, logs, experiments, feature flags, data warehouse/pipelines, APM, customer analytics, CSP, tasks, skills, MCP calls, alerts, and web vitals lack evidence of active use. `signals-scout-error-tracking` is intentionally disabled because the native Error Tracking responders cover that surface; `signals-scout-session-replay` is intentionally disabled because Replay Vision monitors are the dedicated route for that surface. The remaining cross-product scouts are disabled to avoid overlapping the selected baseline on this fresh setup.

**Verified run budget:** 100 runs/day, 0 used today, 100 remaining. The project is enrolled in early access; PostHog's banner directs requests for more capacity to `team-self-driving@posthog.com`.

## Custom scouts

No custom scouts were created. Two product-specific candidates were proposed and declined:

- **Planner follow-through:** would watch whether students explore the Bidding Planner but stop creating or reconciling course plans, only reporting a material sustained fall from the app's normal pattern.
- **Cohort pulse participation:** would watch for unexpectedly weak or falling participation during a live bidding period while ignoring intentionally closed periods.

The candidates were based on `BiddingPlanner.tsx`, `CreditTracker.tsx`, and `PulseCheck.tsx`. Generic anomalies and error/replay defects were ruled out because they are already covered by the active general/product scouts or native routes. If a future custom scout is noisy, set `emit: false` on its scout configuration to keep it in dry-run mode.

## Replay Vision scanners

Replay Vision scanners could not be configured in this run. The scanner inventory request returned `INVALID_API_KEY`, and the subsequent quota-schema request timed out, so no inventory, quota estimate, or scanner create/update call could be safely made.

The two intended monitors remain follow-ups:

| Monitor | Intended scope | Status |
|---|---|---|
| Bidding-planner breakage | Sessions on the planner completion path, covering visible failures in planning, bid budgeting, and saved-plan actions. | Not created — scanner API access unavailable. |
| User frustration | Sessions with rage clicks only, covering visible struggle in planner, tracker, resources, and pulse-check interactions. | Not created — scanner API access unavailable. |

A Replay Vision scanner is an LLM that watches individual session recordings on a schedule and pushes confirmed findings to the inbox. It is the only part of this setup that spends Replay Vision quota; findings have half weight and require independent corroboration before becoming an inbox report.

## Files changed

- Created `posthog-self-driving-report.md` (this report).
- Installed supporting workflow references under `.claude/skills/replay-vision-scanners-core/`, `.claude/skills/replay-vision-scanner-broken-experiences/`, and `.claude/skills/replay-vision-scanner-user-frustration/`.
- No application source files were modified.

## Follow-ups

- [ ] Connect an inbound Support / Conversations channel (email, inbox, or Slack) so the enabled ticket responder receives data.
- [ ] Restore PostHog Replay Vision scanner API access, then create the two monitors described above. Re-run this setup after access is restored to obtain the required scanner inventory and credit estimate first.
- [ ] The project profile was unavailable because no profile has been built yet; this is expected for a first setup and will populate as the project develops activity.
- [ ] The event-schema permission (`property_definition:read`) was unavailable, so custom-scout event discovery could not be independently verified from the server. The proposed candidates were grounded in the existing application capture calls instead.

## What happens next

Fresh scout configurations are picked up by the coordinator within about 30 minutes. Their runs draw from the verified daily budget, cluster findings into reports, and send actionable items to the [Self-driving inbox](https://us.posthog.com/project/596443/inbox).