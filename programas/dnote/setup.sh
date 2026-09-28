#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/../common/go_helper.sh"
install_go_package "github.com/dnote/dnote/pkg/cli@latest"
