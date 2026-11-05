# INTERFACE — design decisions for every UI we build

Read this before building or changing any UI. It is the source of truth for look, feel and interaction.

**Status meanings**
- `CONFIRMED`: Manuchim decided. Never contradict silently. To change it, add a new decision that supersedes it.
- `PROPOSED`: an agent suggested it. Use it, but flag it to Manuchim for confirmation.
- `SUPERSEDED by D-xxx`: kept for history; do not follow.

Agents add new decisions at the bottom with the next ID, and keep the **Current tokens** block in sync.
Timestamp: `TZ=Africa/Lagos date '+%Y-%m-%d %H:%M WAT'`

---

## Current tokens (living summary; must match the decisions below)

```css
:root {
  /* surfaces: black, layered */
  --bg:          #0A0A0A;
  --surface:     #121212;
  --surface-2:   #1A1A1A;
  --border:      #262626;
  --text:        #F5F5F5;
  --text-muted:  #8A8A8A;

  /* brand */
  --accent:       #FF6A00;  /* orange: activity + primary actions only */
  --accent-hover: #FF8533;
  --accent-dim:   rgba(255,106,0,0.14);

  /* message states (PROPOSED, D-004) */
  --state-ready:    #D4D4D4;  /* waiting in queue */
  --state-inflight: #FF6A00;  /* leased to a consumer */
  --state-acked:    #3FB950;  /* done */
  --state-delayed:  #7C8CFF;  /* scheduled / retry backoff */
  --state-dead:     #F04438;  /* dead-lettered */

  --font-ui:   "Geist", system-ui, sans-serif;     /* PROPOSED */
  --font-mono: "Geist Mono", ui-monospace, monospace; /* IDs, payloads, numbers */
  --radius: 8px;
}
```

---

## Decisions

### D-001 · 2026-10-26 01:37 WAT · CONFIRMED · Black and orange, dark-first
Base palette is black surfaces with orange as the brand accent. Dark mode is the primary design; a light theme is optional later.

### D-002 · 2026-10-26 01:37 WAT · CONFIRMED · Live local flow view
A localhost dashboard shows the whole setup in real time: producers → queues → consumers, with messages visibly moving. It is interactive: users can act on the system from it, not just watch.

### D-003 · 2026-10-26 01:37 WAT · PROPOSED · The broker serves its own UI
The UI is embedded in the broker binary and served on start (e.g. `http://localhost:7070`). No separate install, no build step for users. Pillar 1 applies to the UI too.

### D-004 · 2026-10-26 01:37 WAT · PROPOSED · Messages are particles; color = state
In the topology view each message (or sampled message at high throughput) is a dot travelling along edges. Its color is its lifecycle state (see tokens). Motion means flow; a stuck dot means a stuck message.

### D-005 · 2026-10-26 01:37 WAT · PROPOSED · Orange carries meaning
Orange is reserved for "in flight / happening now" and primary actions. It is never decoration. If everything is orange, nothing is.

### D-006 · 2026-10-26 01:37 WAT · PROPOSED · Every message has a timeline
Clicking any message anywhere opens its lifecycle: published → delivered (attempt 1, consumer X) → lease expired → redelivered → acked, with timestamps and durations.

### D-007 · 2026-10-26 01:37 WAT · PROPOSED · "Why" explanations in plain English
Events can explain themselves, e.g. "Redelivered because consumer `email-worker-2` held it for 30s without acking (lease timeout)." This is the learning-curve feature.

### D-008 · 2026-10-26 01:37 WAT · PROPOSED · Failure simulation lives on the canvas
Right-click (or select) a consumer or queue to: kill it, slow it down, make it fail N% of jobs, pause the queue, or restart the broker and watch recovery. Simulations are clearly labeled and reversible in one click.

### D-009 · 2026-10-26 01:37 WAT · PROPOSED · Playground mode with zero code
A first-run demo spins up simulated producers and consumers inside the broker, so the UI is alive before the user writes any code. It can be turned off with one click.

### D-010 · 2026-10-26 01:37 WAT · PROPOSED · Motion is accessible and bounded
Respect `prefers-reduced-motion` (particles become static counters). Cap rendered particles and sample at high throughput, so the UI never falls behind the broker.
