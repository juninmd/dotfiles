#!/usr/bin/env bash
source "$(dirname "$0")/../common/common.sh"
source "$(dirname "$0")/../common/cargo_helper.sh"
echo -e "${c}Installing tealdeer...${r}"
install_cargo_crate tealdeer tldr
echo -e "${c}tealdeer setup complete.${r}"
