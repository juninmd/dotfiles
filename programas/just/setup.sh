#!/usr/bin/env bash
source "$(dirname "$0")/../common/common.sh"
source "$(dirname "$0")/../common/cargo_helper.sh"
echo -e "${c}Installing just...${r}"
install_cargo_crate just just
echo -e "${c}just setup complete.${r}"
