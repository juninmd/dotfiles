#!/usr/bin/env bash
source "$(dirname "$0")/../common/common.sh"
source "$(dirname "$0")/../common/cargo_helper.sh"
echo -e "${c}Installing helix...${r}"
install_cargo_crate helix-term hx
echo -e "${c}helix setup complete.${r}"
