#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Klog (Time tracker)
install_go_package github.com/jotaen/klog/v2/cmd/klog@latest klog
