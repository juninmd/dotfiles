#!/usr/bin/env bash
set -e
c="\033[1;36m"
r="\033[0m"
source "$ROOT_DIR/programas/common/cargo_helper.sh" 2>/dev/null || true
printf "%b\n" "${c}Installing Rye...${r}"
curl -sSf https://rye.astral.sh/get | bash