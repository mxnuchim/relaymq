# EXECUTION — what we did, in order

Append-only, chronological (oldest at top, newest at bottom). One entry per task or meaningful step.
Get the timestamp with: `TZ=Africa/Lagos date '+%Y-%m-%d %H:%M WAT'`

Entry format:

```
## YYYY-MM-DD HH:MM WAT — <short title>
**Goal:** what we were trying to do
**Steps:** numbered list of what was actually executed (commands, edits, decisions)
**Result:** what happened / current state (include failures honestly)
**Files:** files created or changed
**Next:** the obvious next step, if any
```

---

## 2026-10-26 01:36 WAT — Project kickoff, name check, journal + hooks
**Goal:** Validate the product name, set up shared context for future agent sessions.
**Steps:**
1. Searched for "TinyMQ" and "RelayMQ" as existing products.
   - TinyMQ: Evan Miller's 2012 Erlang channel queue (split from Chicago Boss) + a stray Docker image. Small and old, not mainstream.
   - RelayMQ: a hobby project by NathanStangler on GitHub (CLI/Go/C++ clients, 0 stars). Not mainstream.
2. Checked package registries: `relaymq` and `tinymq` both return 404 (free) on crates.io, npm, PyPI.
3. Chose **RelayMQ** as the working name (folder already named relaymq; "Tiny" undersells the UI pillar).
4. Created `journal/` with EXECUTION.md, LEARNINGS.md, INTERFACE.md.
5. Added project hooks in `.claude/settings.json`:
   - `SessionStart` → `.claude/hooks/journal-context.sh` injects the journal into every new session.
   - `Stop` → `.claude/hooks/journal-guard.sh` blocks finishing when ≥3 project files changed since the last EXECUTION entry.
6. Added `CLAUDE.md` with project summary and journaling rules.
**Result:** Scaffolding done. No Rust code yet.
**Files:** journal/*, .claude/settings.json, .claude/hooks/*.sh, CLAUDE.md
**Next:** Settle open decisions (protocol, storage, SDK language, scope of v0.1), then M0/M1.

## 2026-10-27 20:54 WAT — Name locked: RelayMQ
**Goal:** Make the name final and plan how to reserve it.
**Steps:**
1. Manuchim confirmed **RelayMQ** as the final name (TinyMQ dropped).
2. Re-checked availability: `relaymq` is free on crates.io, npm, and PyPI. The npm org/scope `@relaymq` and the GitHub org `relaymq` are also free.
3. Checked registry rules: crates.io bans name squatting without genuine development (RFC 3463). Plan is to reserve the names by publishing a real, minimal 0.0.1 tied to the public repo, not an empty placeholder.
**Result:** Name is final. Registration is pending; Manuchim runs it from his own accounts.
**Files:** journal/EXECUTION.md, journal/LEARNINGS.md
**Next:** Create GitHub org/repo, publish crate `relaymq` 0.0.1, publish npm `relaymq` 0.0.1, create npm org `@relaymq`.

## 2026-10-27 21:23 WAT — Language switch: Rust → Go
**Goal:** Pick the implementation language for RelayMQ.
**Steps:**
1. Compared Rust, Go and Erlang for this product (concurrency model, speed to MVP, correctness guarantees, distribution, prior art: NATS, NSQ and Faktory are Go).
2. Manuchim decided: **Go for RelayMQ**. Rust will be learned through separate projects better suited to Rust's strengths.
3. Updated CLAUDE.md (language, Go conventions), LEARNINGS.md (superseded the Rust-enum rule, added Go state rules and the registry note), and the journal guard hook (ignores Go `bin/` and `vendor/`).
**Result:** Project is now Go. All design decisions and milestones carry over unchanged. The crates.io name is no longer needed.
**Files:** CLAUDE.md, journal/EXECUTION.md, journal/LEARNINGS.md, .claude/hooks/journal-guard.sh
**Next:** Create the GitHub org/repo `relaymq/relaymq`, reserve npm `relaymq`, then M0: `go mod init github.com/relaymq/relaymq` and a CLI skeleton.

## 2026-11-05 12:14 WAT — First commit pushed with the full project context
**Goal:** Get everything we have into the repo's first commit.
**Steps:**
1. Manuchim created the GitHub repo `mxnuchim/relaymq` and the npm org `@relaymq`. The plain npm package `relaymq` isn't published yet; publish it once real code exists.
2. Added a `.gitignore` (.DS_Store, bin/, *.log, .relaymq/).
3. Amended the initial commit (which only had README.md) to include CLAUDE.md, journal/, .claude/ and .gitignore, then force-pushed (with lease) to overwrite it.
**Result:** The repo holds all the project context. Still no Go code.
**Files:** .gitignore, journal/EXECUTION.md
**Next:** M0 + M1 using the Claude Code prompt (Go skeleton, then the queue state machine).
