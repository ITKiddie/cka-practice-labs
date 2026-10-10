#!/usr/bin/env bash
# Restores the control plane manifests saved by setup.sh and starts the kubelet.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/common.sh"

MANIFESTS=/etc/kubernetes/manifests
BACKUP=/var/lib/cka-labs/scenario-14

# Nothing to restore if the scenario was never set up.
[[ -d $BACKUP ]] || exit 0
[[ $EUID -eq 0 ]] || die "Run this as root (in Killercoda you already are; elsewhere use: sudo -i)."

info "Restoring the original control plane manifests..."
cp -p "$BACKUP"/*.yaml "$MANIFESTS"/
rm -rf "$BACKUP"
systemctl start kubelet.service

info "Waiting for the API server to come back (up to 3 minutes)..."
for _ in $(seq 36); do
  if kubectl get --raw /readyz --request-timeout=5s >/dev/null 2>&1; then
    ok "Cluster restored."
    exit 0
  fi
  sleep 5
done
warn "The API server is not ready yet. Give it a minute and check with: kubectl get nodes"
