#!/usr/bin/env bash
source "$ROOT_DIR/programas/common/cargo_helper.sh"
c="\e[32m"
r="\e[0m"
echo -e "${c}Installing atuin (Magical Shell History)...${r}"
install_cargo_crate atuin
