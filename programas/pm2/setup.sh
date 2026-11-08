#!/usr/bin/env bash
set -euo pipefail
if command -v npm &> /dev/null; then
    if npm config get prefix | grep -q '/usr'; then
        sudo npm install -g pm2
    else
        npm install -g pm2
    fi
else
    echo "NPM not found. Skipping pm2 installation."
fi
