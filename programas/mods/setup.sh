#!/usr/bin/env bash
set -euo pipefail
echo "Installing mods..."
source "$PWD/programas/common/cargo_helper.sh"
install_go_package github.com/charmbracelet/mods@latest
