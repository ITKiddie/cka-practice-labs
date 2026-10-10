#!/usr/bin/env bash
# Scenario 8: CRDs
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/common.sh"
require_cluster

# 1st step: cert-manager CRDs v1.14.0
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.0/cert-manager.crds.yaml

scenario_ready
