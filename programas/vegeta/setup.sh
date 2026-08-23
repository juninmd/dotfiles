#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Vegeta (HTTP load testing)
install_go_package github.com/tsenart/vegeta@latest vegeta
