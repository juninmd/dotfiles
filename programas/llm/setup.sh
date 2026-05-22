#!/usr/bin/env bash
source "$(dirname "$0")/../common/common.sh"
echo -e "${c}Installing llm...${r}"
pip3 install llm --break-system-packages 2>/dev/null || pip3 install llm
echo -e "${c}llm setup complete.${r}"
