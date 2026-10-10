#!/usr/bin/env bash
# Scenario 12: PVC
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
source ../../lib/common.sh
require_cluster

# 1st step
apply_generated kubectl create ns mariadb

# 2nd step - YAML file (PV)
kubectl apply -f pv.yaml

# 3rd step: the guide creates mariadb-deploy.yaml with vi. It is copied to your
# home directory instead. Do NOT apply it: you use it when you solve the scenario.
cp mariadb-deploy.yaml "$HOME/mariadb-deploy.yaml"
ok "Created $HOME/mariadb-deploy.yaml (not applied, you will use it to solve the scenario)."

scenario_ready
