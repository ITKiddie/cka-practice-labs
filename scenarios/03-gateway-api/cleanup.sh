#!/usr/bin/env bash
# Deletes what scenario 3 creates. The Gateway API CRDs stay installed.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/common.sh"
require_cluster

# Fails harmlessly when the Gateway API CRDs are not installed yet.
kubectl delete gatewayclass nginx-class --ignore-not-found >/dev/null 2>&1 || true
delete_ns web-app
