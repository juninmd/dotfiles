#!/usr/bin/env bash
set -euo pipefail
if ! command -v pnpm &> /dev/null; then
  npm install -g pnpm
fi
pnpm add -g turbo
