#!/bin/bash
c='\e[32m'
r='\e[0m'
# gh-dash (GitHub CLI dashboard)
if command -v gh &> /dev/null; then
    if ! gh extension list | grep -q "^dlvhdr/gh-dash\s"; then
        echo -e "${c}Installing gh-dash extension...${r}"
        gh extension install dlvhdr/gh-dash
    else
        echo -e "${c}gh-dash already installed.${r}"
    fi
else
    echo -e "${c}gh not found, skipping gh-dash extension installation.${r}"
fi
# --- CLOUD NATIVE & SYSTEM TOOLS ---
