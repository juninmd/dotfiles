#!/usr/bin/env bash
set -e

c='\e[32m'
r='\e[0m'

if ! command -v gosec &> /dev/null; then
    printf "%b\n" "${c}Installing gosec...${r}"
    SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
    if [ -f "$SCRIPT_DIR/../common/go_helper.sh" ]; then
        source "$SCRIPT_DIR/../common/go_helper.sh"
        install_go_package "github.com/securego/gosec/v2/cmd/gosec@latest"
    else
        go install github.com/securego/gosec/v2/cmd/gosec@latest
    fi
else
    printf "%b\n" "${c}gosec is already installed.${r}"
fi
