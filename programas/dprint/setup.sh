#!/usr/bin/env bash

# dprint is a pluggable and configurable code formatting platform
# It is written in Rust.

# Source common variables and functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." &> /dev/null && pwd)"

# Include cargo helper
source "${ROOT_DIR}/programas/common/cargo_helper.sh"

echo "Installing dprint..."
install_cargo_crate dprint
