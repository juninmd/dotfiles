#!/bin/bash
c='\e[32m'
r='\e[0m'
# Syft (SBOM generation)
if ! command -v syft &> /dev/null; then
    printf "%b\n" "${c}Installing syft...${r}"
    curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sudo /usr/bin/env bash -s -- -b /usr/local/bin
else
    printf "%b\n" "${c}syft already installed.${r}"
fi
