#!/usr/bin/env bash
source "$(dirname "$0")/../common/common.sh"
echo -e "${c}Installing deno...${r}"
curl -fsSL https://deno.land/x/install/install.sh | /usr/bin/env sh
echo -e "${c}deno setup complete.${r}"
