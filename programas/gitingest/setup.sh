#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'

# Gitingest (Replace git clone with AI friendly prompt)
if ! command -v gitingest &> /dev/null; then
    echo -e "${c}Installing gitingest...${r}"
    python3 -m pip install gitingest --break-system-packages 2>/dev/null || python3 -m pip install gitingest # NOSONAR
else
    echo -e "${c}gitingest already installed.${r}"
fi
