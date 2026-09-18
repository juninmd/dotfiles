#!/usr/bin/env bash
set -euo pipefail
c='\e[32m'
r='\e[0m'
printf "%b\n" "${c}Installing zig (Modern programming language)...${r}"
sudo snap install zig --classic
