#!/bin/bash
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing gleam (Modern programming language)...${r}"
wget -q https://github.com/gleam-lang/gleam/releases/download/v1.2.0/gleam-v1.2.0-x86_64-unknown-linux-musl.tar.gz
tar xzf gleam-v1.2.0-x86_64-unknown-linux-musl.tar.gz
sudo mv gleam /usr/local/bin/
rm gleam-v1.2.0-x86_64-unknown-linux-musl.tar.gz
