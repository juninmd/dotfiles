#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Ko (Fast Go container builds)
install_go_package github.com/google/ko@latest ko
