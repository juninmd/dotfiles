#!/bin/bash
c='\e[32m'
r='\e[0m'
# howdoi (Instant coding answers)
if ! command -v howdoi &> /dev/null; then
    echo -e "${c}Installing howdoi...${r}"
    if command -v uv &> /dev/null; then
        uv tool install howdoi
    else
        python3 -m pip install howdoi --break-system-packages 2>/dev/null || python3 -m pip install howdoi # NOSONAR
    fi
else
    echo -e "${c}howdoi already installed.${r}"
fi
