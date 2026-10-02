#!/usr/bin/env bash
set -euo pipefail
c='\e[32m'
r='\e[0m'
printf "%b\n" "${c}Installing Waypoint...${r}"

if command -v waypoint &> /dev/null; then
    printf "%b\n" "${c}Waypoint is already installed.${r}"
    exit 0
fi

VERSION="0.11.0"
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    ARCH="amd64"
elif [[ "$ARCH" == "aarch64" ]]; then
    ARCH="arm64"
fi
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

ZIP_FILE="waypoint_${VERSION}_${OS}_${ARCH}.zip"
URL="https://releases.hashicorp.com/waypoint/${VERSION}/${ZIP_FILE}"

printf "%b\n" "${c}Downloading ${ZIP_FILE}...${r}"
curl --proto '=https' --tlsv1.2 -sSL "$URL" -o "/tmp/${ZIP_FILE}"

printf "%b\n" "${c}Unzipping Waypoint...${r}"
unzip -q -o "/tmp/${ZIP_FILE}" -d /tmp/

printf "%b\n" "${c}Moving to /usr/local/bin...${r}"
sudo mv /tmp/waypoint /usr/local/bin/waypoint
sudo chmod +x /usr/local/bin/waypoint

rm "/tmp/${ZIP_FILE}"

printf "%b\n" "${c}Waypoint installed successfully!${r}"
