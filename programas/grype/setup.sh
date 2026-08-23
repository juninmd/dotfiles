#!/bin/bash
c='\e[32m'
r='\e[0m'
# Grype (Vulnerability scanner)
if ! command -v grype &> /dev/null; then
    echo -e "${c}Installing grype...${r}"
    curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sudo /usr/bin/env bash -s -- -b /usr/local/bin
else
    echo -e "${c}grype already installed.${r}"
fi
