#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing superfile...${r}"
bash -c "$(curl -sLo- https://superfile.netlify.app/install.sh)" || true
echo -e "${c}superfile setup complete.${r}"
