#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMON_DIR="$SCRIPT_DIR/../common"
source "$COMMON_DIR/cargo_helper.sh"

# Doggo (Modern DNS Client)
if ! command -v doggo &> /dev/null; then
    echo -e "${c}Installing doggo...${r}"
    if command -v go &> /dev/null; then
        go install github.com/mr-karan/doggo/cmd/doggo@latest
    else
        echo -e "${c}Go not found, skipping doggo installation.${r}"
    fi
else
    echo -e "${c}doggo already installed.${r}"
fi
