#!/bin/bash
set -euo pipefail
echo "Installing k9s-cli..."
curl -sS https://webinstall.dev/k9s | /usr/bin/env sh
echo "k9s successfully installed!"
