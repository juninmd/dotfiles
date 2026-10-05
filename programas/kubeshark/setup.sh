#!/bin/bash
c='\e[32m'
r='\e[0m'
printf "%b\n" "${c}Installing Kubeshark...${r}"
sh <(curl -Ls https://kubeshark.co/install)
