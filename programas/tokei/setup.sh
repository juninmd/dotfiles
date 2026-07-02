#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMON_DIR="$SCRIPT_DIR/../common"
source "$COMMON_DIR/cargo_helper.sh"

# Tokei (Code Statistics)
install_cargo_crate tokei
