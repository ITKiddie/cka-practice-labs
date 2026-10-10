#!/usr/bin/env bash
# Deletes what scenario 7 creates.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/common.sh"
require_cluster

delete_ns echo-sound
