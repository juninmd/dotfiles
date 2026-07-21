#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Fq (JQ for binary)
install_cargo_crate fq
