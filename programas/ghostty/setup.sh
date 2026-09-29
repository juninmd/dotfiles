#!/bin/bash
c='\e[32m'
r='\e[0m'
printf "%b\n" "${c}Installing Ghostty...${r}"
# Assuming Debian/Ubuntu, it is distributed via deb or apt, but building from source or using snap is common.
# Ghostty requires adding a specific PPA on Ubuntu.
sudo add-apt-repository -y ppa:ramonpoca/ghostty
sudo apt-get update
sudo apt-get install -y ghostty
printf "%b\n" "${c}Ghostty installed!${r}"
