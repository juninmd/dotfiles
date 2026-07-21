#!/usr/bin/env bash
set -euo pipefail
c="\033[1;36m"
r="\033[0m"
source "$ROOT_DIR/programas/common/cargo_helper.sh" 2>/dev/null || true
echo -e "${c}Installing moon...${r}"
curl -fsSL https://moonrepo.dev/install/moon.sh | bash # NOSONAR
