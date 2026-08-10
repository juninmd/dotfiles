#!/bin/bash
if command -v npm &> /dev/null; then
    npm install -g @usebruno/cli # NOSONAR
else
    echo "npm is required to install bruno-cli"
    exit 1
fi
