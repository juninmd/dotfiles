#!/bin/bash
if command -v npm &> /dev/null; then
    npm install -g @usebruno/cli
else
    echo "npm is required to install bruno-cli"
fi
