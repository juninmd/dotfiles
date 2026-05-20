#!/usr/bin/env sh
set -eu

echo "Installing cline..."

if ! command -v cline > /dev/null 2>&1; then
  sudo npm install -g @cline/cli
fi
