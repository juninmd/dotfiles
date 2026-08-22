#!/bin/bash
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing vivid...${r}"

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
if [ -f "$SCRIPT_DIR/../common/cargo_helper.sh" ]; then
    source "$SCRIPT_DIR/../common/cargo_helper.sh"
    install_cargo_crate "vivid"
else
    cargo install vivid
fi

echo -e "${c}vivid installed.${r}"