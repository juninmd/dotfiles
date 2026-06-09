#!/usr/bin/env bash
set -e
c="\033[1;36m"
r="\033[0m"
source "$ROOT_DIR/programas/common/cargo_helper.sh" 2>/dev/null || true
echo -e "${c}Installing llm...${r}"
if command -v uv &> /dev/null; then
    uv tool install llm
elif command -v pip3 &> /dev/null; then
    pip3 install llm --break-system-packages 2>/dev/null || pip3 install llm
else
    echo -e "${c}Neither uv nor pip3 found, skipping llm installation.${r}"
fi
