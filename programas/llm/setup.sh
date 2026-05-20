#!/usr/bin/env sh
set -eu

echo "Installing llm..."

if ! command -v llm > /dev/null 2>&1; then
  if command -v uv > /dev/null 2>&1; then
    uv tool install llm
  else
    pip3 install llm --break-system-packages 2>/dev/null || pip3 install llm
  fi
fi
