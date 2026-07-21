#!/bin/bash
c='\e[32m'
r='\e[0m'
# Checkov (IaC static analysis)
if ! command -v checkov &> /dev/null; then
    echo -e "${c}Installing checkov...${r}"
    if command -v uv &> /dev/null; then
        uv tool install checkov
    else
        python3 -m pip install checkov --break-system-packages 2>/dev/null || python3 -m pip install checkov # NOSONAR
    fi
else
    echo -e "${c}checkov already installed.${r}"
fi
