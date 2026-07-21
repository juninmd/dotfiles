#!/usr/bin/env bash
set -euo pipefail
c="\033[1;32m"
r="\033[0m"
source "$ROOT_DIR/programas/common/cargo_helper.sh" 2>/dev/null || true
echo -e "${c}Installing pkgx...${r}"
curl -fsS https://pkgx.sh | /usr/bin/env sh # NOSONAR
