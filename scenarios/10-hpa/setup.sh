#!/usr/bin/env bash
# Scenario 10: HPA
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
source ../../lib/common.sh
require_cluster

# 1st step
apply_generated kubectl create ns autoscale

# 2nd step - YAML file (Deployment)
kubectl apply -n autoscale -f deployment.yaml

# 3rd step
apply_generated kubectl expose deployment apache-deployment -n autoscale --port=80 --target-port=80

wait_rollout autoscale apache-deployment
scenario_ready
