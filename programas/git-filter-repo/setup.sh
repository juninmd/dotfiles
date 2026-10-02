#!/bin/bash
c='\e[32m'
r='\e[0m'
# Git-filter-repo (Git history rewriting)
if ! command -v git-filter-repo &> /dev/null; then
    printf "%b\n" "${c}Installing git-filter-repo...${r}"
    if command -v uv &> /dev/null; then
        uv tool install git-filter-repo
    else
        pip3 install git-filter-repo --break-system-packages 2>/dev/null || pip3 install git-filter-repo
    fi
else
    printf "%b\n" "${c}git-filter-repo already installed.${r}"
fi
