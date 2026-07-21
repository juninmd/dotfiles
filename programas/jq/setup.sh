#!/bin/bash
c='\e[32m'
r='\e[0m'
# Jq (JSON Processor)
if ! command -v jq &> /dev/null; then
    echo -e "${c}Installing jq...${r}"
    sudo apt install -y jq
else
    echo -e "${c}jq already installed.${r}"
fi
