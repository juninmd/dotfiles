#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Httpx (Fast and multi-purpose HTTP toolkit)
install_go_package github.com/projectdiscovery/httpx/cmd/httpx@latest httpx
