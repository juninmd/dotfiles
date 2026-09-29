#!/bin/bash
c='\e[32m'
r='\e[0m'
# gh-dash (GitHub CLI dashboard)
if command -v gh &> /dev/null; then
    if ! gh extension list | grep -q "^dlvhdr/gh-dash\s"; then
        printf "%b\n" "${c}Installing gh-dash extension...${r}"
        gh extension install dlvhdr/gh-dash
    else
        printf "%b\n" "${c}gh-dash already installed.${r}"
    fi
else
    printf "%b\n" "${c}gh not found, skipping gh-dash extension installation.${r}"
fi
# --- CLOUD NATIVE & SYSTEM TOOLS ---
