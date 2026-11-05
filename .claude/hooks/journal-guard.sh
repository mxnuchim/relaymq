#!/usr/bin/env bash
# Stop hook: won't let an agent finish a large task until journal/ is updated.
# "Large" = at least RELAYMQ_JOURNAL_THRESHOLD project files (default 3)
# modified since journal/EXECUTION.md was last written.
set -u
INPUT="$(cat)"
ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
J="$ROOT/journal"
[ -d "$J" ] || exit 0

# Already blocked once this turn: let it stop (prevents infinite loops).
if printf '%s' "$INPUT" | grep -q '"stop_hook_active"[[:space:]]*:[[:space:]]*true'; then
  exit 0
fi

REF="$J/EXECUTION.md"
if [ ! -f "$REF" ]; then
  echo '{"decision":"block","reason":"journal/EXECUTION.md is missing. Recreate it (see CLAUDE.md) and log this task before finishing."}'
  exit 0
fi

THRESHOLD="${RELAYMQ_JOURNAL_THRESHOLD:-3}"
CHANGED=$(cd "$ROOT" && find . -type f -newer "$REF" \
  -not -path './.git/*' -not -path './target/*' -not -path './bin/*' -not -path './vendor/*' -not -path '*/node_modules/*' \
  -not -path '*/dist/*' -not -path './journal/*' -not -path './.claude/*' \
  -not -name '.DS_Store' -not -name '*.log' 2>/dev/null | wc -l | tr -d ' ')

if [ "$CHANGED" -ge "$THRESHOLD" ]; then
  printf '{"decision":"block","reason":"%s"}\n' \
"Journal check: ${CHANGED} project files changed since the last journal/EXECUTION.md entry. Before finishing: (1) append a timestamped entry to journal/EXECUTION.md covering goal, steps, result, files, next. (2) If you hit a problem, a fix, or a non-obvious fact, append it to journal/LEARNINGS.md. (3) If you made or changed any UI or visual decision, add it to journal/INTERFACE.md and keep its tokens block in sync. Get the time with: TZ=Africa/Lagos date. Then finish."
fi
exit 0
