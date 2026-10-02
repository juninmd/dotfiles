#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'
printf "%b\n" "${c}Installing superfile...${r}"
bash -c "$(curl -sLo- https://superfile.netlify.app/install.sh)" || true
printf "%b\n" "${c}superfile setup complete.${r}"
