#!/usr/bin/env bash
# Deletes what scenario 12 creates, including your PVC and ~/mariadb-deploy.yaml.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/common.sh"
require_cluster

delete_ns mariadb
kubectl delete pv pv-mariadb --ignore-not-found >/dev/null
rm -f "$HOME/mariadb-deploy.yaml"
