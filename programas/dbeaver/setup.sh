#!/bin/bash
c='\e[32m' # Green Color
r='\e[0m' # Reset Color

printf "%b\n" "${c}Installing DBeaver Community Edition...${r}"

if command -v snap &> /dev/null; then
    sudo snap install dbeaver-ce
    printf "%b\n" "${c}DBeaver installed successfully!${r}"
else
    printf "%b\n" "${c}Snap is not available, skipping DBeaver installation.${r}"
fi
