#!/usr/bin/env bash
# Scenario 9: Network Policy
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
source ../../lib/common.sh
require_cluster

# 1st step
apply_generated kubectl create ns frontend

# 2nd step
apply_generated kubectl create ns backend

# 3rd step - YAML file (FrontEnd)
kubectl apply -n frontend -f frontend.yaml

# 4th step - YAML file (BackEnd)
kubectl apply -n backend -f backend.yaml

# 5th step
apply_generated kubectl expose deploy backend -n backend --port 80 --target-port=80 --name backend-service

wait_rollout frontend frontend
wait_rollout backend backend
scenario_ready
