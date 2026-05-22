#!/usr/bin/env bash
source "$(dirname "$0")/../common/common.sh"
echo -e "${c}Installing moon...${r}"
curl -fsSL https://moonrepo.dev/install/moon.sh | /usr/bin/env sh
echo -e "${c}moon setup complete.${r}"
