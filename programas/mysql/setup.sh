#!/usr/bin/env bash
set -e

echo "Installing MySQL Client..."
sudo apt-get update
sudo apt-get install -y mysql-client
echo "MySQL client installed successfully."
