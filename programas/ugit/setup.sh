#!/usr/bin/env bash
set -euo pipefail
c='\e[32m'
r='\e[0m'
printf "%b\n" "${c}Installing ugit...${r}"

wget -qO- "https://raw.githubusercontent.com/Bhupesh-V/ugit/master/install.sh" | bash -

printf "%b\n" "${c}ugit installed.${r}"