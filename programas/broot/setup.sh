#!/usr/bin/env bash
source "$(dirname "$0")/../common/common.sh"
source "$(dirname "$0")/../common/cargo_helper.sh"
echo -e "${c}Installing broot...${r}"
install_cargo_crate broot broot
echo -e "${c}broot setup complete.${r}"
