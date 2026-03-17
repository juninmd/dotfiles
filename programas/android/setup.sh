#!/bin/bash
c='\e[32m'
r='\e[0m'

echo -e "${c}Installing Android Studio & SDK...${r}"

# Update apt first
sudo apt update

# Install dependencies
sudo apt install -y libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386 wget unzip

# Check if snap is available and install android-studio
if command -v snap &> /dev/null; then
    sudo snap install android-studio --classic
else
    echo -e "${c}Snap not found. Cannot install android-studio via snap.${r}"
fi

echo -e "${c}Android setup complete.${r}"
