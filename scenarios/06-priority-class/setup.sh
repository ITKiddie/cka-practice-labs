#!/usr/bin/env bash
# Scenario 6: PriorityClass
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
source ../../lib/common.sh
require_cluster

# 1st step
apply_generated kubectl create ns priority

# 2nd step - YAML (Priority Class)
kubectl apply -f priorityclass.yaml

# 3rd step - YAML (Deployment)
kubectl apply -f deployment.yaml

wait_rollout priority busybox-logger
scenario_ready
