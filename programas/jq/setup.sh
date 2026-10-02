#!/bin/bash
c='\e[32m'
r='\e[0m'
# Jq (JSON Processor)
if ! command -v jq &> /dev/null; then
    printf "%b\n" "${c}Installing jq...${r}"
    sudo apt install -y jq
else
    printf "%b\n" "${c}jq already installed.${r}"
fi
