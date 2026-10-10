#!/usr/bin/env bash
# Deletes what scenario 17 creates. ~/tls.crt and ~/tls.key are kept
# (setup.sh overwrites them).
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/common.sh"
require_cluster

delete_ns nginx-static
