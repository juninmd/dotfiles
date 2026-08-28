#!/usr/bin/env bash
set -e
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing tmate...${r}"
sudo apt update
sudo apt install -y tmate
echo -e "${c}tmate setup complete.${r}"
