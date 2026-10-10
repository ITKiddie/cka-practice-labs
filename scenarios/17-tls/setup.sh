#!/usr/bin/env bash
# Scenario 17: TLS
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
source ../../lib/common.sh
require_cluster

# 1st step
apply_generated kubectl create ns nginx-static

# 2nd step: like in the guide, tls.key and tls.crt stay in your home directory.
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout "$HOME/tls.key" -out "$HOME/tls.crt" -subj "/CN=ITKiddie.k8s.local" >/dev/null 2>&1

# 3rd step
apply_generated kubectl create secret tls nginx-tls --cert="$HOME/tls.crt" --key="$HOME/tls.key" -n nginx-static

# 4th step - YAML file (ConfigMap)
kubectl apply -n nginx-static -f configmap.yaml

# 5th step - YAML file (Deployment)
kubectl apply -n nginx-static -f deployment.yaml

# 6th step
apply_generated kubectl expose deploy nginx-static -n nginx-static --port=443 --target-port=443 --name=nginx-static

wait_rollout nginx-static nginx-static
scenario_ready
