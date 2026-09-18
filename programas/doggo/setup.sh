#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMON_DIR="$SCRIPT_DIR/../common"
source "$COMMON_DIR/cargo_helper.sh"

# Doggo (Modern DNS Client)
if ! command -v doggo &> /dev/null; then
    printf "%b\n" "${c}Installing doggo...${r}"
    if command -v go &> /dev/null; then
        go install github.com/mr-karan/doggo/cmd/doggo@latest
    else
        printf "%b\n" "${c}Go not found, skipping doggo installation.${r}"
    fi
else
    printf "%b\n" "${c}doggo already installed.${r}"
fi
