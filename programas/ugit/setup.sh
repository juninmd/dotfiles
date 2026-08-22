#!/bin/bash
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing ugit...${r}"

curl -sL https://raw.githubusercontent.com/Bhupesh-V/ugit/master/install.sh | bash

echo -e "${c}ugit installed.${r}"