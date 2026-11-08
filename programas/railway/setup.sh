#!/usr/bin/env bash
set -euo pipefail
if command -v npm &> /dev/null; then
    if npm config get prefix | grep -q '/usr'; then
        sudo npm install -g @railway/cli
    else
        npm install -g @railway/cli
    fi
else
    curl -fsSL https://railway.app/install.sh | /usr/bin/env sh
fi
