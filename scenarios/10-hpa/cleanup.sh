#!/usr/bin/env bash
# Deletes what scenario 10 creates, including the HPA you added.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/common.sh"
require_cluster

delete_ns autoscale
