#!/usr/bin/env bash
set -e

source "$(dirname "$0")/../common/cargo_helper.sh"

c="\e[36m"
r="\e[0m"

echo -e "${c}Installing atuin...${r}"
install_cargo_crate atuin
echo -e "${c}atuin setup complete.${r}"
