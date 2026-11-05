# LEARNINGS — things we know now so we never solve them twice

Append-only, timestamped. Read before starting work. If a learning turns out wrong, don't delete it: add a new entry that supersedes it and mark the old one `(SUPERSEDED by <date>)`.
Timestamp: `TZ=Africa/Lagos date '+%Y-%m-%d %H:%M WAT'`

Entry format:

```
## YYYY-MM-DD HH:MM WAT — [tag] <title>
**Context:** where this came up
**Learning:** the insight, bug cause, or fact
**Rule going forward:** what to do (or never do) from now on
```

Tags: [concept] [go] [design] [bug] [tooling] [perf] [product]

---

## 2026-10-26 01:36 WAT — [product] Name check
**Context:** Picking a name.
**Learning:** "TinyMQ" = Evan Miller's 2012 Erlang lib; "RelayMQ" = a 0-star hobby repo set (NathanStangler). Neither is mainstream. Both names are free on crates.io, npm, PyPI (checked 2026-10-26).
**Rule going forward:** Use RelayMQ. Reserve the crate/npm names before any public announcement.

## 2026-10-26 01:36 WAT — [concept] The core contract of a job queue (rule SUPERSEDED by 2026-10-27 21:23 WAT for the Go version)
**Context:** First-principles study.
**Learning:** A broker is a state machine per message: `ready → leased (in-flight) → acked`, with branches `leased → ready` (nack or lease expired), `→ delayed` (retry backoff), `→ dead` (max attempts). Everything else (UI, metrics, SDKs) is a view of these transitions.
**Rule going forward:** Model message state as one Rust `enum` with explicit transitions. Every transition emits an event. Never mutate state anywhere else.

## 2026-10-26 01:36 WAT — [concept] At-least-once is the honest default
**Context:** Delivery guarantees.
**Learning:** A worker can finish the job and crash before its ack arrives, so the broker must redeliver and the job runs twice. "Exactly-once delivery" over a network is not achievable in general. Exactly-once *effects* come from idempotent handlers (dedupe keys).
**Rule going forward:** RelayMQ promises at-least-once. Docs and UI must say so plainly. Provide an optional idempotency/dedupe key at publish time.

## 2026-10-26 01:36 WAT — [concept] Leases (visibility timeouts) are how crashes get detected
**Context:** How a broker knows a consumer died.
**Learning:** When a message is delivered it gets a lease deadline. If no ack arrives before then, it goes back to ready. Long jobs extend the lease (heartbeat). Too short a lease → duplicate work; too long → slow recovery.
**Rule going forward:** Default lease 30s, configurable per queue, extendable by the SDK automatically while the handler runs.

## 2026-10-26 01:36 WAT — [concept] Durability is a tradeoff knob: fsync
**Context:** Persistence.
**Learning:** Writing to a file isn't durable until fsync. fsync per message is safe but slow; batching fsync every N ms is fast but can lose the last N ms on power loss. An append-only log (WAL) and a replay on startup is the classic design.
**Rule going forward:** Append-only log + replay. Make the fsync policy explicit (`always` | `interval`) and default to `interval` (~100ms) for a dev-friendly broker.

## 2026-10-26 01:36 WAT — [design] Observability falls out of the event stream
**Context:** Pillar 3.
**Learning:** If every state transition emits an event, the same stream powers the live UI (WebSocket), per-message timelines, metrics counters, and "why" explanations. No separate monitoring stack is needed.
**Rule going forward:** The internal event bus is a first-class module, not an afterthought. UI features read from events. They never poll internal structures.

## 2026-10-27 20:54 WAT — [product] Reserving package names without breaking registry rules
**Context:** Securing `relaymq` before posting publicly.
**Learning:** crates.io is first-come-first-served, but its terms (RFC 3463) prohibit crates that "exist only to reserve a name" with no genuine functionality or development. Squatted names can be removed. Publishes are effectively permanent: versions can be yanked, not edited. npm unpublish is limited after 72h.
**Rule going forward:** Reserve names with a small but real 0.0.1 that links to the public repo and has an honest README ("early development"). Never publish secrets or junk to a registry. Run `--dry-run` first.

## 2026-10-27 21:23 WAT — [go] Message state rules, Go version (supersedes the Rust enum rule)
**Context:** Project switched from Rust to Go.
**Learning:** Go has no enums that carry data, so the compiler won't stop invalid states like a "ready" message holding a stale consumer ID, or an ack on a message that isn't leased. Go also compiles data races without complaint. Correctness has to come from structure, tests and the race detector instead.
**Rule going forward:** Define a typed `State` (`type State uint8` with consts), and change state only through methods that check the current state and return an error on an invalid transition. Exactly one goroutine owns each queue's maps; nobody else touches them. Run every test with `-race`. Write table tests for every transition, including the ack-vs-lease-expiry race.

## 2026-10-27 21:23 WAT — [product] Go needs no package registry name
**Context:** Name reservation after the switch to Go.
**Learning:** Go modules are identified by their repository path (e.g. `github.com/relaymq/relaymq`), and pkg.go.dev indexes them automatically. There is no central name to claim. The crates.io reservation is no longer needed for this project.
**Rule going forward:** Secure the GitHub org `relaymq` (that *is* the Go package name) and the npm name `relaymq` for the TypeScript SDK. Skip crates.io.
