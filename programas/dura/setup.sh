#!/usr/bin/env bash

# dura is a background process that automatically commits your uncommitted changes
# It is written in Rust.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." &> /dev/null && pwd)"

source "${ROOT_DIR}/programas/common/cargo_helper.sh"

echo "Installing dura..."
install_cargo_crate dura
