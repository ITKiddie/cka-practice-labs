#!/usr/bin/env bash
# Deletes what scenario 6 creates. PriorityClasses you created yourself
# while solving it are not deleted.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/common.sh"
require_cluster

delete_ns priority
kubectl delete priorityclass high-priority --ignore-not-found >/dev/null
