#!/usr/bin/env bash
# Scenario 14: BONUS: Hardest CKA Question (TROUBLESHOOT)
#
# Breaks the control plane on purpose. The guide makes these edits with vi;
# this script makes the same edits with sed. The original manifests are
# backed up so "./cka.sh cleanup 14" can restore the cluster.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/common.sh"

MANIFESTS=/etc/kubernetes/manifests
BACKUP=/var/lib/cka-labs/scenario-14

[[ $EUID -eq 0 ]] || die "Run this as root (in Killercoda you already are; elsewhere use: sudo -i)."
[[ -d $MANIFESTS ]] || die "$MANIFESTS not found. Run this on the control plane node (controlplane)."
for f in kube-scheduler.yaml kube-apiserver.yaml kube-controller-manager.yaml; do
  [[ -f $MANIFESTS/$f ]] || die "$MANIFESTS/$f not found."
done

warn "This scenario breaks the cluster on purpose: kubectl stops working until you fix it."
warn "To undo it without solving it, run: ./cka.sh cleanup 14"
if [[ -t 0 ]]; then
  read -r -p "Continue? [y/N] " answer
  [[ $answer == [yY]* ]] || die "Cancelled. Nothing was changed."
fi

mkdir -p "$BACKUP"
cp -p "$MANIFESTS"/kube-scheduler.yaml "$MANIFESTS"/kube-apiserver.yaml "$MANIFESTS"/kube-controller-manager.yaml "$BACKUP"/

# 1st step
cd "$MANIFESTS"

# 2nd step: kube-scheduler cpu request 25m -> 1900m
sed -i -E 's/^([[:space:]]+cpu:[[:space:]]*).*/\11900m/' kube-scheduler.yaml
grep -qE '^[[:space:]]+cpu:[[:space:]]*1900m$' kube-scheduler.yaml \
  || warn "Could not change the cpu request in kube-scheduler.yaml"

# 3rd step: kube-apiserver --etcd-servers=https://127.0.0.1:2379 -> port 2380
sed -i -E 's#(--etcd-servers=https://[^:,[:space:]]+):2379#\1:2380#' kube-apiserver.yaml
grep -qE -- '--etcd-servers=https://[^:,[:space:]]+:2380' kube-apiserver.yaml \
  || warn "Could not change the etcd port in kube-apiserver.yaml"

# 4th step: kube-controller-manager cpu request 25m -> 3m
sed -i -E 's/^([[:space:]]+cpu:[[:space:]]*).*/\13m/' kube-controller-manager.yaml
grep -qE '^[[:space:]]+cpu:[[:space:]]*3m$' kube-controller-manager.yaml \
  || warn "Could not change the cpu request in kube-controller-manager.yaml"

# 5th step
systemctl stop kubelet.service

scenario_ready
