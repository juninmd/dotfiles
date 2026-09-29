#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$ROOT_DIR/programas/common/go_helper.sh"

echo "Instalando dnote..."
install_go_package github.com/dnote/dnote@latest
