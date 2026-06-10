#!/usr/bin/env bash
set -euo pipefail
echo -e "\e[32mInstalling Mods...\e[0m"
source "$PWD/programas/common/cargo_helper.sh"
install_go_package github.com/charmbracelet/mods@latest