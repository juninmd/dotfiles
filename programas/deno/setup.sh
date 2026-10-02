#!/usr/bin/env bash
set -euo pipefail
c="\033[1;36m"
r="\033[0m"
source "$ROOT_DIR/programas/common/cargo_helper.sh" 2>/dev/null || true
printf "%b\n" "${c}Installing deno...${r}"
curl -fsSL https://deno.land/x/install/install.sh | /usr/bin/env sh