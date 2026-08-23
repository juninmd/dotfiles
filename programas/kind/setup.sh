#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Kind (Local Kubernetes)
install_go_package sigs.k8s.io/kind@latest kind
