#!/usr/bin/env bash
c='\e[32m'
r='\e[0m'
if ! command -v pgcli &> /dev/null; then
    printf "%b\n" "${c}Installing pgcli...${r}"
    if command -v pipx &> /dev/null; then
        pipx install pgcli
    else
        pip3 install --break-system-packages pgcli
    fi
else
    printf "%b\n" "${c}pgcli is already installed.${r}"
fi
