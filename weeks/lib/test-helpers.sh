# Shared helpers for end-of-week tests. Source this; don't run it.
# Usage in a week test:
#   source "$(dirname "$0")/../lib/test-helpers.sh"
#   check "CoreDNS is running" "kubectl -n kube-system get deploy coredns"
#   ask "Can you explain ClusterIP vs headless Service in one sentence?"
#   finish
#
# Conventions:
#   check  <label> <cmd...>   run cmd, PASS if exit 0, FAIL otherwise (auto checks)
#   want   <label> <cmd...>   like check but non-fatal (warns, doesn't fail the run)
#   ask    <question>         self-graded knowledge check (you answer out loud / in notes)
#   file_has <path> <regex>   PASS if file exists and matches regex
#   finish                    print summary, exit non-zero if any hard check failed

set -uo pipefail

_PASS=0; _FAIL=0; _WARN=0; _ASK=0
_RED=$'\033[31m'; _GRN=$'\033[32m'; _YEL=$'\033[33m'; _CYN=$'\033[36m'; _RST=$'\033[0m'

check() {
  local label="$1"; shift
  if "$@" >/dev/null 2>&1; then
    printf "  ${_GRN}PASS${_RST}  %s\n" "$label"; _PASS=$((_PASS+1))
  else
    printf "  ${_RED}FAIL${_RST}  %s\n      ${_CYN}(%s)${_RST}\n" "$label" "$*"; _FAIL=$((_FAIL+1))
  fi
}

want() {
  local label="$1"; shift
  if "$@" >/dev/null 2>&1; then
    printf "  ${_GRN}PASS${_RST}  %s\n" "$label"; _PASS=$((_PASS+1))
  else
    printf "  ${_YEL}WARN${_RST}  %s (optional)\n" "$label"; _WARN=$((_WARN+1))
  fi
}

file_has() {
  local path="$1" regex="$2"
  if [ -f "$path" ] && grep -Eq "$regex" "$path"; then
    printf "  ${_GRN}PASS${_RST}  %s matches /%s/\n" "$path" "$regex"; _PASS=$((_PASS+1))
  else
    printf "  ${_RED}FAIL${_RST}  %s missing or no match /%s/\n" "$path" "$regex"; _FAIL=$((_FAIL+1))
  fi
}

ask() {
  printf "  ${_CYN}Q${_RST}    %s\n" "$1"; _ASK=$((_ASK+1))
}

section() { printf "\n${_CYN}== %s ==${_RST}\n" "$1"; }

finish() {
  printf "\n${_CYN}---------------------------------------------${_RST}\n"
  printf "Auto checks: ${_GRN}%d passed${_RST}, ${_RED}%d failed${_RST}, ${_YEL}%d warn${_RST}.  Self-grade Qs: %d\n" \
    "$_PASS" "$_FAIL" "$_WARN" "$_ASK"
  if [ "$_ASK" -gt 0 ]; then
    printf "Answer the ${_CYN}Q${_RST} items out loud or in your week note — they're the real test.\n"
  fi
  if [ "$_FAIL" -gt 0 ]; then
    printf "${_RED}Week not done: fix the FAILs above.${_RST}\n"; exit 1
  fi
  printf "${_GRN}Auto checks green. If you can answer the Qs, tick the ROADMAP box.${_RST}\n"
}
