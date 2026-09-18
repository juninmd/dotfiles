#!/bin/bash
set -e
c="\e[32m"
r="\e[0m"
printf "%b\n" "${c}Installing Windsurf (AI Code Editor)...${r}"
wget -qO- "https://windsurf.codeium.com/install.sh" > /tmp/windsurf_install.sh && chmod +x /tmp/windsurf_install.sh && /tmp/windsurf_install.sh || echo "Download windsurf directly if install script fails."
printf "%b\n" "${c}Windsurf setup complete.${r}"
