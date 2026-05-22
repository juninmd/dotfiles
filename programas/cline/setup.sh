#!/usr/bin/env bash
source "$(dirname "$0")/../common/common.sh"
echo -e "${c}Installing cline...${r}"
sudo npm install -g @cline/cli
echo -e "${c}cline setup complete.${r}"
