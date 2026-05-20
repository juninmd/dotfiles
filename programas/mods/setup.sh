#!/usr/bin/env sh
set -eu

echo "Installing mods..."

if ! command -v mods > /dev/null 2>&1; then
  go install github.com/charmbracelet/mods@latest
fi
