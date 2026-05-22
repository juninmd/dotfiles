#!/usr/bin/env bash
source "$(dirname "$0")/../common/common.sh"
echo -e "${c}Installing opentofu...${r}"
curl --proto =https --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
chmod +x install-opentofu.sh
./install-opentofu.sh --install-method standalone
rm install-opentofu.sh
echo -e "${c}opentofu setup complete.${r}"
