#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$ROOT_DIR/programas/common/cargo_helper.sh" 2>/dev/null || true
install_cargo_crate agg
