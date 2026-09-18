#!/bin/bash
c='\e[32m'
r='\e[0m'
# Atlas (Database migrations)
if ! command -v atlas &> /dev/null; then
    printf "%b\n" "${c}Installing atlas...${r}"
    curl -sSf https://atlasgo.sh | /usr/bin/env bash
else
    printf "%b\n" "${c}atlas already installed.${r}"
fi
