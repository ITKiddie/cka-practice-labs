# shellcheck shell=bash
# Shared helpers for the scenario scripts. This file is sourced, not executed.

if [[ -t 1 ]]; then
  C_BLUE=$'\033[1;34m' C_GREEN=$'\033[1;32m' C_YELLOW=$'\033[1;33m' C_RED=$'\033[1;31m' C_RESET=$'\033[0m'
else
  C_BLUE='' C_GREEN='' C_YELLOW='' C_RED='' C_RESET=''
fi

info() { printf '%s==>%s %s\n' "$C_BLUE" "$C_RESET" "$*"; }
ok()   { printf '%s✔%s %s\n' "$C_GREEN" "$C_RESET" "$*"; }
warn() { printf '%s!%s %s\n' "$C_YELLOW" "$C_RESET" "$*" >&2; }
die()  { printf '%s✘%s %s\n' "$C_RED" "$C_RESET" "$*" >&2; exit 1; }

# Stops early with a clear message when kubectl cannot talk to the cluster.
require_cluster() {
  command -v kubectl >/dev/null 2>&1 \
    || die "kubectl not found. Run this in the Killercoda Kubernetes playground."
  kubectl get --raw /readyz --request-timeout=10s >/dev/null 2>&1 \
    || die "Cannot reach the Kubernetes API server. If you ran scenario 14, restore the cluster with: ./cka.sh cleanup 14"
}

# Runs a "kubectl create/expose ..." command from the guide through
# --dry-run=client and applies the result, so a step can run twice
# without failing with AlreadyExists.
apply_generated() {
  "$@" --dry-run=client -o yaml | kubectl apply -f -
}

delete_ns() {
  kubectl delete ns "$@" --ignore-not-found --wait=true --timeout=180s >/dev/null
}

# Waits for deployments to be ready. Not fatal: image pulls can be slow.
wait_rollout() {
  local ns=$1 deploy
  shift
  info "Waiting for the pods to be ready..."
  for deploy in "$@"; do
    kubectl rollout status "deploy/$deploy" -n "$ns" --timeout=180s >/dev/null 2>&1 \
      || warn "deployment/$deploy in namespace $ns is not ready yet. Check it with: kubectl get pods -n $ns"
  done
}

PLAYLIST_URL="https://www.youtube.com/playlist?list=PLkDZsCgo3Isr4NB5cmyqG7OZwYEx5XOjM"

no_setup_needed() {
  ok "No prior setup needed. You can resolve it directly by watching the video."
  info "Video solutions: $PLAYLIST_URL"
}

scenario_ready() {
  ok "Scenario ready. Now solve the question shown in the video."
  info "Video solutions: $PLAYLIST_URL"
}
