#!/usr/bin/env sh
set -eu

echo "Installing moon..."

if ! command -v moon > /dev/null 2>&1; then
  curl -fsSL https://moonrepo.dev/install/moon.sh | /usr/bin/env sh
fi
