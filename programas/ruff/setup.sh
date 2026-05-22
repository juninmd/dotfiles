#!/usr/bin/env bash
source "$(dirname "$0")/../common/common.sh"
echo -e "${c}Installing ruff...${r}"
pip3 install ruff --break-system-packages 2>/dev/null || pip3 install ruff
echo -e "${c}ruff setup complete.${r}"
