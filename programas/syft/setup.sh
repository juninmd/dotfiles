#!/bin/bash
c='\e[32m'
r='\e[0m'
# Syft (SBOM generation)
if ! command -v syft &> /dev/null; then
    echo -e "${c}Installing syft...${r}"
    curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sudo /usr/bin/env bash -s -- -b /usr/local/bin # NOSONAR
else
    echo -e "${c}syft already installed.${r}"
fi
