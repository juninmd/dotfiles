#!/usr/bin/env bash

c="\033[1;36m"
r="\033[0m"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$ROOT_DIR/programas/common/cargo_helper.sh"

echo -e "${c}Installing atuin...${r}"
install_cargo_crate atuin
echo -e "${c}atuin installed successfully.${r}"
