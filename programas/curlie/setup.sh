#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMON_DIR="$SCRIPT_DIR/../common"
source "$COMMON_DIR/cargo_helper.sh"

# Curlie (curl + httpie)
if ! command -v curlie &> /dev/null; then
    echo -e "${c}Installing curlie...${r}"
    if command -v go &> /dev/null; then
        go install github.com/rs/curlie@latest
    else
        echo -e "${c}Go not found, skipping curlie installation.${r}"
    fi
else
    echo -e "${c}curlie already installed.${r}"
fi
