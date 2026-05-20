#!/usr/bin/env sh
set -eu

echo "Installing flox..."

if ! command -v flox > /dev/null 2>&1; then
  curl -fsSL https://install.flox.dev | /usr/bin/env sh || true
fi
