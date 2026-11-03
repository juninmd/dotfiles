#!/usr/bin/env bash
set -euo pipefail
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin \
    launch=n \
    dest="$HOME/.local"
