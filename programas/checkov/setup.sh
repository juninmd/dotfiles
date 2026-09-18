#!/bin/bash
c='\e[32m'
r='\e[0m'
# Checkov (IaC static analysis)
if ! command -v checkov &> /dev/null; then
    printf "%b\n" "${c}Installing checkov...${r}"
    if command -v uv &> /dev/null; then
        uv tool install checkov
    else
        pip3 install checkov --break-system-packages 2>/dev/null || pip3 install checkov
    fi
else
    printf "%b\n" "${c}checkov already installed.${r}"
fi
