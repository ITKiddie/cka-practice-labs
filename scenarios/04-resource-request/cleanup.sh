#!/usr/bin/env bash
# Deletes what scenario 4 creates.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/common.sh"
require_cluster

kubectl delete deploy wordpress --ignore-not-found >/dev/null
