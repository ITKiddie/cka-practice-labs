#!/usr/bin/env bash
# Scenario 2: SideCar
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
source ../../lib/common.sh
require_cluster

# 1st YAML file
kubectl apply -f deployment.yaml

# 2nd YAML file
kubectl apply -f service.yaml

wait_rollout default wordpress
scenario_ready
