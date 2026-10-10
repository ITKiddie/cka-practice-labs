#!/usr/bin/env bash
# Deletes what scenario 9 creates, including the NetworkPolicies you added.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/common.sh"
require_cluster

delete_ns frontend backend
