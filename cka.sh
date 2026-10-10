#!/usr/bin/env bash
# CKA Practice Labs by IT Kiddie: prepares each practice scenario in the
# Killercoda Kubernetes playground (killercoda.com/playgrounds/scenario/kubernetes).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCENARIOS="$ROOT/scenarios"
# shellcheck source=lib/common.sh
source "$ROOT/lib/common.sh"

# "setup all" skips these: 4 reuses the wordpress deployment from scenario 2,
# and 14 breaks the control plane on purpose.
ALL_SKIP=" 04 14 "

usage() {
  cat <<EOF
Usage: ./cka.sh <command> [scenario]

Commands:
  list            List the scenarios
  setup <n>       Prepare scenario <n>. Running it again resets the scenario.
  cleanup <n>     Delete what scenario <n> created
  setup all       Prepare every scenario except 4 and 14

Example:
  ./cka.sh setup 2

Video solutions: $PLAYLIST_URL
EOF
}

scenario_number() { basename "$1" | cut -d- -f1; }
scenario_title()  { sed -n '2s/^# //p' "$1/setup.sh"; }
needs_no_setup()  { grep -q '^no_setup_needed' "$1/setup.sh"; }

scenario_dir() {
  local n=$1 matches
  [[ $n =~ ^[0-9]+$ ]] || die "The scenario must be a number, for example: ./cka.sh setup 2"
  matches=("$SCENARIOS/$(printf '%02d' "$((10#$n))")"-*)
  [[ -d ${matches[0]} ]] || die "Scenario $n does not exist. See the list with: ./cka.sh list"
  printf '%s\n' "${matches[0]}"
}

list_scenarios() {
  local dir note
  for dir in "$SCENARIOS"/*/; do
    dir=${dir%/}
    note=''
    if needs_no_setup "$dir"; then note='  (no setup needed)'; fi
    printf '  %s%s\n' "$(scenario_title "$dir")" "$note"
  done
}

run_setup() {
  local dir=$1
  printf '\n'
  info "$(scenario_title "$dir")"
  # Start from a clean state so the scenario can be repeated.
  if [[ -f $dir/cleanup.sh ]]; then bash "$dir/cleanup.sh"; fi
  bash "$dir/setup.sh"
}

setup_all() {
  local dir
  for dir in "$SCENARIOS"/*/; do
    dir=${dir%/}
    if [[ $ALL_SKIP == *" $(scenario_number "$dir") "* ]] || needs_no_setup "$dir"; then continue; fi
    run_setup "$dir"
  done
  printf '\n'
  warn "Skipped scenario 4 (it reuses the wordpress deployment from scenario 2) and scenario 14 (it breaks the cluster)."
  warn "Run them on their own when you get to them: ./cka.sh setup 4   /   ./cka.sh setup 14"
}

case ${1:-} in
  list)
    list_scenarios
    ;;
  setup | cleanup)
    if [[ $# -lt 2 ]]; then usage; exit 1; fi
    if [[ $1 == setup && $2 == all ]]; then setup_all; exit 0; fi
    dir=$(scenario_dir "$2")
    if [[ $1 == setup ]]; then
      run_setup "$dir"
    elif [[ -f $dir/cleanup.sh ]]; then
      bash "$dir/cleanup.sh"
      ok "Scenario $2 cleaned up."
    else
      ok "Scenario $2 does not create anything, so there is nothing to clean up."
    fi
    ;;
  '' | -h | --help | help)
    usage
    printf '\nScenarios:\n'
    list_scenarios
    ;;
  *)
    usage
    exit 1
    ;;
esac
