#!/usr/bin/env bash
set -euo pipefail
if command -v apt-get &> /dev/null; then
  sudo apt-get update && sudo apt-get install -y entr
elif command -v dnf &> /dev/null; then
  sudo dnf install -y entr
elif command -v pacman &> /dev/null; then
  sudo pacman -S --noconfirm entr
else
  echo "Package manager not supported for entr"
fi
