#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Crane (Interact with remote images)
install_go_package github.com/google/go-containerregistry/cmd/crane@latest crane
