#!/usr/bin/env bash
set -euo pipefail

# Cyberpunk/Synthwave color formatting
c="\e[38;2;255;126;219m" # Pink (#ff7edb)
r="\e[0m"               # Reset

source "$(dirname "$0")/../common/cargo_helper.sh"

echo -e "${c}Installing television (Blazing fast fuzzy finder)...${r}"

install_cargo_crate television tv
