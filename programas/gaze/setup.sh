#!/usr/bin/env bash
set -euo pipefail
c="\e[32m"
r="\e[0m"
echo -e "${c}Installing gaze...${r}"
if ! command -v gaze &> /dev/null; then
    if command -v go &> /dev/null; then
        go install github.com/wtetsu/gaze/cmd/gaze@latest # NOSONAR
    else
        echo -e "${c}Go is required to install gaze.${r}"
    fi
fi
