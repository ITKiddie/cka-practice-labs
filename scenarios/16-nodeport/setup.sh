#!/usr/bin/env bash
# Scenario 16: Node Port
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/common.sh"
require_cluster

# 1st step
apply_generated kubectl create ns relative

# 2nd step
apply_generated kubectl create deploy nodeport-deployment -n relative --image=nginx --replicas=2

wait_rollout relative nodeport-deployment
scenario_ready
