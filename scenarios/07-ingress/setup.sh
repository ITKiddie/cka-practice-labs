#!/usr/bin/env bash
# Scenario 7: Ingress
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
source ../../lib/common.sh
require_cluster

# 1st step
apply_generated kubectl create ns echo-sound

# 2nd step - YAML file (Deployment)
kubectl apply -n echo-sound -f deployment.yaml

wait_rollout echo-sound echoserver-deployment
scenario_ready
