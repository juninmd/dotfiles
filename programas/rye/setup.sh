#!/usr/bin/env sh
set -eu

echo "Installing rye..."

if ! command -v rye > /dev/null 2>&1; then
  curl -sSf https://rye.astral.sh/get | RYE_INSTALL_OPTION="--yes" /usr/bin/env sh
fi
