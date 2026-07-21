#!/bin/bash
c='\e[32m' # Green Color
r='\e[0m' # Reset Color

echo -e "${c}Installing WezTerm...${r}"

# Add the repository key
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg # NOSONAR
echo 'deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list # NOSONAR

# Install Wezterm
sudo apt update # NOSONAR
sudo apt install -y wezterm # NOSONAR

echo -e "${c}WezTerm installed successfully!${r}"
