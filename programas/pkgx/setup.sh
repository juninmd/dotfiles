#!/usr/bin/env bash
source "$(dirname "$0")/../common/common.sh"
echo -e "${c}Installing pkgx...${r}"
curl -fsS https://pkgx.sh | /usr/bin/env sh
echo -e "${c}pkgx setup complete.${r}"
