#!/bin/bash
c='\e[32m'
r='\e[0m'
printf "%b\n" "${c}Installing Chatblade...${r}"
pipx install chatblade || pip3 install --break-system-packages chatblade
