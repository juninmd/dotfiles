#!/usr/bin/env bash
set -e
c="\033[1;36m"
r="\033[0m"
source "$ROOT_DIR/programas/common/cargo_helper.sh" 2>/dev/null || true
echo -e "${c}Installing flox...${r}"
curl -fsSL https://raw.githubusercontent.com/flox/flox/main/install.sh | bash
