#!/bin/bash
echo -e "\e[32mInstalling AWS CLI v2...\e[0m"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -o -q awscliv2.zip
sudo ./aws/install --update
rm -rf aws awscliv2.zip
