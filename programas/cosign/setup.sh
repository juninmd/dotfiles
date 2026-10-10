#!/bin/bash
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing cosign...${r}"
curl -sL https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64 | sudo tee /usr/local/bin/cosign > /dev/null
sudo chmod +x /usr/local/bin/cosign
echo -e "${c}cosign installed!${r}"
