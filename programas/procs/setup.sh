#!/usr/bin/env bash
source "$(dirname "$0")/../common/common.sh"
source "$(dirname "$0")/../common/cargo_helper.sh"
echo -e "${c}Installing procs...${r}"
install_cargo_crate procs procs
echo -e "${c}procs setup complete.${r}"
