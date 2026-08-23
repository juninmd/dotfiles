#!/usr/bin/env bash
set -euo pipefail
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing ugit...${r}"

wget -qO- "https://raw.githubusercontent.com/Bhupesh-V/ugit/master/install.sh" | bash -

echo -e "${c}ugit installed.${r}"