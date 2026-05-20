#!/usr/bin/env sh
set -eu

echo "Installing pkgx..."

if ! command -v pkgx > /dev/null 2>&1; then
  curl -fsS https://pkgx.sh | /usr/bin/env sh
fi
