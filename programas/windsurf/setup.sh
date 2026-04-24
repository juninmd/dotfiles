#!/bin/bash
set -e
c="\e[32m"
r="\e[0m"
echo -e "${c}Installing Windsurf (AI Code Editor)...${r}"
wget -qO- "https://windsurf.codeium.com/install.sh" > /tmp/windsurf_install.sh && chmod +x /tmp/windsurf_install.sh && /tmp/windsurf_install.sh || echo "Download windsurf directly if install script fails."
echo -e "${c}Windsurf setup complete.${r}"
