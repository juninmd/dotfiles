#!/usr/bin/env bash
source "$(dirname "$0")/../common/common.sh"
source "$(dirname "$0")/../common/cargo_helper.sh"
echo -e "${c}Installing nushell...${r}"
install_cargo_crate nu nu
echo -e "${c}nushell setup complete.${r}"
