#!/usr/bin/env bash
source "$(dirname "$0")/../common/common.sh"
source "$(dirname "$0")/../common/cargo_helper.sh"
echo -e "${c}Installing pueue...${r}"
install_cargo_crate pueue pueue
echo -e "${c}pueue setup complete.${r}"
