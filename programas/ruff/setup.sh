#!/usr/bin/env sh
set -eu

echo "Installing ruff..."

if ! command -v ruff > /dev/null 2>&1; then
  pip3 install ruff --break-system-packages 2>/dev/null || pip3 install ruff
fi
