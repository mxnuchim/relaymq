#!/usr/bin/env bash
# SessionStart hook: injects the project journal into every new session's context.
ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
J="$ROOT/journal"
[ -d "$J" ] || exit 0
echo "=== RelayMQ project journal (auto-loaded). Follow the rules in CLAUDE.md. ==="
echo
echo "--- journal/INTERFACE.md (full: UI decisions you must follow) ---"
cat "$J/INTERFACE.md" 2>/dev/null
echo
echo "--- journal/LEARNINGS.md (last 150 lines; read the full file if relevant) ---"
tail -n 150 "$J/LEARNINGS.md" 2>/dev/null
echo
echo "--- journal/EXECUTION.md (last 80 lines: where we left off) ---"
tail -n 80 "$J/EXECUTION.md" 2>/dev/null
exit 0
