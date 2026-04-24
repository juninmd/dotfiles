#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing posting...${r}"
if command -v uv &> /dev/null; then
    uv tool install posting
elif command -v pip3 &> /dev/null; then
    pip3 install posting --break-system-packages 2>/dev/null || pip3 install posting
else
    echo -e "${c}Neither uv nor pip3 found, skipping posting installation.${r}"
fi
echo -e "${c}posting setup complete.${r}"
