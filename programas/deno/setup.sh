#!/usr/bin/env sh
set -eu

echo "Installing deno..."

if ! command -v deno > /dev/null 2>&1; then
  curl -fsSL https://deno.land/x/install/install.sh | /usr/bin/env sh
fi
