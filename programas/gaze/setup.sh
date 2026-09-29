#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/../common/go_helper.sh"
install_go_package "github.com/wtetsu/gaze/cmd/gaze@latest"
