#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# TruffleHog (Secrets Scanner)
install_go_package github.com/trufflesecurity/trufflehog/v3@latest trufflehog
