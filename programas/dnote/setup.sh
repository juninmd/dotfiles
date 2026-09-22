#!/usr/bin/env bash
set -euo pipefail
c="\e[32m"
r="\e[0m"
echo -e "${c}Installing dnote...${r}"

if ! command -v dnote &> /dev/null; then
    if command -v go &> /dev/null; then
        go install github.com/dnote/dnote/cmd/dnote@latest
    else
        echo -e "${c}Go is required to install dnote.${r}"
    fi
fi
