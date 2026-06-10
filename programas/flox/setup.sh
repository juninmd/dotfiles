#!/bin/sh
set -e
echo -e "\e[32mInstalling flox...\e[0m"
source "$ROOT_DIR/programas/common/cargo_helper.sh" 2>/dev/null || true
curl -fsSL https://install.flox.dev/ | sh