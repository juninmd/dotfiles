#!/bin/bash
c='\e[32m'
r='\e[0m'

printf "%b\n" "${c}Installing Android Studio & SDK...${r}"

# Update apt first
sudo apt update

# Install dependencies
sudo apt install -y libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386 wget unzip

# Check if snap is available and install android-studio
if command -v snap &> /dev/null; then
    sudo snap install android-studio --classic
else
    printf "%b\n" "${c}Snap not found. Cannot install android-studio via snap.${r}"
fi

printf "%b\n" "${c}Android setup complete.${r}"
