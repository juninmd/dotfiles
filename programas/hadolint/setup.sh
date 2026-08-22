#!/bin/bash
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing hadolint...${r}"

URL="https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64"
wget -qO /tmp/hadolint "$URL"
chmod +x /tmp/hadolint
sudo mv /tmp/hadolint /usr/local/bin/hadolint

echo -e "${c}hadolint installed.${r}"