#!/usr/bin/env bash
set -e

c='\e[32m'
r='\e[0m'

if ! command -v overmind &> /dev/null; then
    printf "%b\n" "${c}Installing overmind...${r}"
    SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
    if [ -f "$SCRIPT_DIR/../common/go_helper.sh" ]; then
        source "$SCRIPT_DIR/../common/go_helper.sh"
        install_go_package "github.com/DarthSim/overmind/v2@latest"
    else
        go install github.com/DarthSim/overmind/v2@latest
    fi
else
    printf "%b\n" "${c}overmind is already installed.${r}"
fi
