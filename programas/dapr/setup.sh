#!/bin/bash
# Dapr CLI (Modern tool for building distributed applications)
echo "Installing Dapr CLI..."
wget -q https://raw.githubusercontent.com/dapr/cli/master/install/install.sh -O install_dapr.sh
chmod +x install_dapr.sh
./install_dapr.sh
rm install_dapr.sh
