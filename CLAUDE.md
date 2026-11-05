# RelayMQ

A lightweight, local-first message broker for background jobs, written in Go. It has dead-simple setup, built-in observability, and a live interactive UI that makes message behavior easy to understand.

Owner: Manuchim. **This is primarily a learning project** (message-broker internals, built in Go). Optimize for clarity and understanding over cleverness. Explain non-obvious Go or systems choices in code comments and in journal/LEARNINGS.md.

**Language: Go (decided 2026-10-27, replaces Rust).** Rust is being learned in separate projects, not this one. Go conventions: one goroutine owns each queue's state (actor pattern; other goroutines send it commands over channels). Always run tests with `go test -race ./...`. Prefer the standard library; add dependencies only when they clearly pay for themselves.

## Pillars (every feature must serve at least one)
1. **Dead-simple setup:** one binary, zero config, working in minutes.
2. **Lightweight messaging:** single node, clear at-least-once delivery and ack semantics.
3. **First-class observability:** queues, messages, consumers, attempts, failures, redeliveries, all built in.
4. **Immersive UI:** live topology + message lifecycle + interactive failure simulation.

Non-goals: clustering, replication, rivaling RabbitMQ or Kafka, enterprise features.
North star for developer experience: zustand vs redux. Tiny API surface, sensible defaults, no ceremony.

## The journal (mandatory)
`journal/` holds the project's memory across sessions. A SessionStart hook loads it automatically.

| File | What goes in it | When |
|---|---|---|
| `journal/EXECUTION.md` | Timestamped, chronological log of what was executed: goal, steps, result, files, next | During long tasks (at milestones) and at the end of every large task |
| `journal/LEARNINGS.md` | Problems hit, root causes, fixes, non-obvious facts, with a "rule going forward" | Whenever something cost more than a few minutes or would surprise a future session |
| `journal/INTERFACE.md` | UI and design decisions (D-xxx), plus the live design tokens | Whenever any visual or interaction decision is made or changed |

Rules:
- Timestamps: run `TZ=Africa/Lagos date '+%Y-%m-%d %H:%M WAT'`. Never guess the time.
- Append only. Don't rewrite history; supersede entries instead.
- Before solving a problem, check LEARNINGS.md for it. Before building UI, follow INTERFACE.md.
- Agents may only add `PROPOSED` design decisions. Only Manuchim makes them `CONFIRMED`.
- Log honestly, including failures and dead ends.
- If you delegate to subagents, the main agent logs their work. Subagents don't write to the journal directly, to avoid conflicting edits.
- A Stop hook (`.claude/hooks/journal-guard.sh`) blocks finishing when ≥3 project files changed since the last EXECUTION entry. Satisfy it with a real entry; never just touch the file.

## Git
- No AI attribution in commits or PRs: no `Co-Authored-By: Claude` trailers, no session links, no "Generated with" lines. Commits are authored by Manuchim.
