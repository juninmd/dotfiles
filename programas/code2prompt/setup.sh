#!/usr/bin/env bash
set -euo pipefail

# Cyberpunk/Synthwave color formatting
c="\e[38;2;255;126;219m" # Pink (#ff7edb)
r="\e[0m"               # Reset

. "$(dirname "$0")/../common/cargo_helper.sh"

echo -e "${c}Installing code2prompt (Convert codebase to LLM prompt)...${r}"

install_cargo_crate code2prompt
