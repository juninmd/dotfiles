#!/bin/bash
c='\e[32m'
r='\e[0m'
# Grype (Vulnerability scanner)
if ! command -v grype &> /dev/null; then
    printf "%b\n" "${c}Installing grype...${r}"
    curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sudo /usr/bin/env bash -s -- -b /usr/local/bin
else
    printf "%b\n" "${c}grype already installed.${r}"
fi
