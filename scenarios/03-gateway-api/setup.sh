#!/usr/bin/env bash
# Scenario 3: Gateway API
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
source ../../lib/common.sh
require_cluster

# 1st step: Gateway API CRDs v1.1.0
info "Installing the Gateway API CRDs (v1.1.0)..."
if ! kubectl apply -k "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v1.1.0" >/dev/null; then
  warn "kubectl apply -k failed. Installing the same CRDs from the v1.1.0 release file instead."
  kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.1.0/standard-install.yaml >/dev/null
fi

# 2nd step
apply_generated kubectl create ns web-app

# 3rd step (Apply YAML file)
kubectl apply -n web-app -f deployment.yaml

# 4th step (Apply YAML file)
kubectl apply -n web-app -f service.yaml

# 5th step: self-signed certificate for gateway.web.k8s.local
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout "$tmp/tls.key" -out "$tmp/tls.crt" \
  -subj "/CN=gateway.web.k8s.local/O=web" >/dev/null 2>&1

# 6th step: TLS secret (the certificate files are deleted afterwards)
apply_generated kubectl create secret tls web-tls --cert="$tmp/tls.crt" --key="$tmp/tls.key" -n web-app

# 7th step (YAML file)
kubectl apply -n web-app -f ingress.yaml

# Last step (YAML file GatewayClass)
kubectl wait --for condition=established crd/gatewayclasses.gateway.networking.k8s.io --timeout=60s >/dev/null
kubectl apply -f gatewayclass.yaml

wait_rollout web-app web-deployment
scenario_ready
