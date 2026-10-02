#!/usr/bin/env bash
set -euo pipefail
c="\033[1;36m"
r="\033[0m"
source "$ROOT_DIR/programas/common/cargo_helper.sh" 2>/dev/null || true
printf "%b\n" "${c}Installing llm...${r}"
if command -v uv > /dev/null 2>&1; then
    uv tool install llm
elif command -v pip3 > /dev/null 2>&1; then
    pip3 install llm --break-system-packages 2>/dev/null || pip3 install llm
else
    printf "%b\n" "${c}Neither uv nor pip3 found, skipping llm installation.${r}"
fi