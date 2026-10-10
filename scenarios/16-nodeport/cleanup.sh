#!/usr/bin/env bash
# Deletes what scenario 16 creates, including the NodePort service you added.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/common.sh"
require_cluster

delete_ns relative
