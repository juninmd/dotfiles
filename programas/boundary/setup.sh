#!/usr/bin/env bash
set -euo pipefail
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing Boundary...${r}"

if command -v boundary &> /dev/null; then
    echo -e "${c}Boundary is already installed.${r}"
    exit 0
fi

VERSION="0.20.3"
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    ARCH="amd64"
elif [[ "$ARCH" == "aarch64" ]]; then
    ARCH="arm64"
fi
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

ZIP_FILE="boundary_${VERSION}_${OS}_${ARCH}.zip"
URL="https://releases.hashicorp.com/boundary/${VERSION}/${ZIP_FILE}"

echo -e "${c}Downloading ${ZIP_FILE}...${r}"
curl --proto '=https' --tlsv1.2 -sSL "$URL" -o "/tmp/${ZIP_FILE}"

echo -e "${c}Unzipping Boundary...${r}"
unzip -q -o "/tmp/${ZIP_FILE}" -d /tmp/

echo -e "${c}Moving to /usr/local/bin...${r}"
sudo mv /tmp/boundary /usr/local/bin/boundary
sudo chmod +x /usr/local/bin/boundary

rm "/tmp/${ZIP_FILE}"

echo -e "${c}Boundary installed successfully!${r}"
