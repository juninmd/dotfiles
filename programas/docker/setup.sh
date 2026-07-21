#!/bin/bash
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing Docker Engine...${r}"
# Add Docker's official GPG key:
sudo apt-get update # NOSONAR
sudo apt-get install -y ca-certificates curl # NOSONAR
sudo install -m 0755 -d /etc/apt/keyrings # NOSONAR
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc # NOSONAR
sudo chmod a+r /etc/apt/keyrings/docker.asc # NOSONAR

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \ # NOSONAR
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null # NOSONAR
sudo apt-get update # NOSONAR
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin # NOSONAR
sudo usermod -aG docker $USER
echo -e "${c}Docker Engine installed! Please log out and back in for group changes to take effect.${r}"
