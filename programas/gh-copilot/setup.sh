#!/usr/bin/env bash
set -euo pipefail

if ! command -v gh > /dev/null 2>&1; then
    echo "GitHub CLI (gh) must be installed to install gh-copilot."
else
    echo "Installing gh-copilot extension..."
    gh extension install github/gh-copilot --force || true
fi
