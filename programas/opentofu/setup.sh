#!/usr/bin/env sh
set -eu

echo "Installing opentofu..."

if ! command -v tofu > /dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
  chmod +x install-opentofu.sh
  ./install-opentofu.sh --install-method standalone
  rm install-opentofu.sh
fi
