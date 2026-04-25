#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'

# Gitingest (Replace git clone with AI friendly prompt)
if ! command -v gitingest &> /dev/null; then
    echo -e "${c}Installing gitingest...${r}"
    pip3 install gitingest --break-system-packages 2>/dev/null || pip3 install gitingest
else
    echo -e "${c}gitingest already installed.${r}"
fi
