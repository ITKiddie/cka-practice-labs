#!/usr/bin/env bash
# Scenario 4: Resource Request
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
source ../../lib/common.sh
require_cluster

# 1st step
kubectl apply -f deployment.yaml

wait_rollout default wordpress
scenario_ready
