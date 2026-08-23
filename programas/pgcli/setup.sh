#!/bin/bash
c='\e[32m'
r='\e[0m'
if ! command -v pgcli &> /dev/null; then
    echo -e "${c}Installing pgcli...${r}"
    if command -v pipx &> /dev/null; then
        pipx install pgcli
    else
        python3 -m pip install --break-system-packages pgcli
    fi
else
    echo -e "${c}pgcli is already installed.${r}"
fi
