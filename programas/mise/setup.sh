#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'

# Mise (Polyglot Tool Version Manager)
if ! command -v mise &> /dev/null; then
    printf "%b\n" "${c}Installing mise...${r}"
    curl https://mise.jdx.dev/install.sh | sh
else
    printf "%b\n" "${c}mise already installed.${r}"
fi