#!/usr/bin/env sh
set -eu

echo "Installing devenv..."

if ! command -v devenv > /dev/null 2>&1; then
  curl -fsSL https://devenv.sh/get-started/install.sh | /usr/bin/env sh || true
fi
