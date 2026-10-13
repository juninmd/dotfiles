#!/usr/bin/env bash
set -e

c='\e[32m'
r='\e[0m'

if ! command -v k3sup &> /dev/null; then
    printf "%b\n" "${c}Installing k3sup...${r}"
    curl -sLS https://get.k3sup.dev | /usr/bin/env sh
    sudo install -m 755 k3sup /usr/local/bin/
    rm -f k3sup
else
    printf "%b\n" "${c}k3sup is already installed.${r}"
fi
