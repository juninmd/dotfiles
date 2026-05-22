#!/usr/bin/env bash
source "$(dirname "$0")/../common/common.sh"
source "$(dirname "$0")/../common/cargo_helper.sh"
echo -e "${c}Installing hyperfine...${r}"
install_cargo_crate hyperfine hyperfine
echo -e "${c}hyperfine setup complete.${r}"
