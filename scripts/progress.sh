#!/usr/bin/env bash
# Count ticked milestones in ROADMAP.md and print completion %.
set -euo pipefail
ROADMAP="${1:-ROADMAP.md}"
[ -f "$ROADMAP" ] || { echo "Roadmap not found: $ROADMAP" >&2; exit 1; }

done_count=$(grep -cE '^[[:space:]]*- \[x\]' "$ROADMAP" || true)
todo_count=$(grep -cE '^[[:space:]]*- \[ \]' "$ROADMAP" || true)
total=$(( done_count + todo_count ))
[ "$total" -gt 0 ] || { echo "No checkboxes found in $ROADMAP"; exit 0; }

pct=$(( done_count * 100 / total ))
filled=$(( pct / 5 )); empty=$(( 20 - filled ))
bar=""
for ((i=0; i<filled; i++)); do bar+="#"; done
for ((i=0; i<empty;  i++)); do bar+="-"; done
echo "Progress: ${done_count}/${total} milestones  [${bar}] ${pct}%"
