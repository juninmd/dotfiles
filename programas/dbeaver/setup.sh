#!/bin/bash
c='\e[32m' # Green Color
r='\e[0m' # Reset Color

echo -e "${c}Installing DBeaver Community Edition...${r}"

if command -v snap &> /dev/null; then
    sudo snap install dbeaver-ce
    echo -e "${c}DBeaver installed successfully!${r}"
else
    echo -e "${c}Snap is not available, skipping DBeaver installation.${r}"
fi
