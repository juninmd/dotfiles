#!/usr/bin/env bash
source "$(dirname "$0")/../common/common.sh"
source "$(dirname "$0")/../common/cargo_helper.sh"
echo -e "${c}Installing mods...${r}"
install_go_package github.com/charmbracelet/mods@latest mods
echo -e "${c}mods setup complete.${r}"
