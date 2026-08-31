#!/usr/bin/env bash
set -euo pipefail
curl -s -L "https://github.com/loft-sh/devspace/releases/latest/download/devspace-linux-amd64" -o devspace
sudo install -c -m 0755 devspace /usr/local/bin
rm devspace
