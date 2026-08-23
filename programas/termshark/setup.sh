#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Termshark (Terminal UI for Wireshark/tshark)
install_go_package github.com/gcla/termshark/v2/cmd/termshark@latest termshark
