#!/bin/bash
c='\e[32m'
r='\e[0m'
# Steampipe (Select * from cloud)
if ! command -v steampipe &> /dev/null; then
    echo -e "${c}Installing steampipe...${r}"
    sudo /bin/sh -c "$(curl -fsSL https://steampipe.io/install/steampipe.sh)" # NOSONAR
else
    echo -e "${c}steampipe already installed.${r}"
fi
