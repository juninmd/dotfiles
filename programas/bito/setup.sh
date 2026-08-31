#!/usr/bin/env bash
set -euo pipefail
curl -#L https://alpha.bito.ai/downloads/cli/install.sh -o install.sh # NOSONAR
chmod +x install.sh
./install.sh
rm install.sh
