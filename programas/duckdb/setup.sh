#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'

# DuckDB (In-process SQL OLAP DBMS)
if ! command -v duckdb &> /dev/null; then
    echo -e "${c}Installing duckdb...${r}"
    wget -q https://github.com/duckdb/duckdb/releases/latest/download/duckdb_cli-linux-amd64.zip -O /tmp/duckdb.zip
    unzip -o -q /tmp/duckdb.zip -d /tmp
    sudo mv /tmp/duckdb /usr/local/bin/duckdb
    rm /tmp/duckdb.zip
else
    echo -e "${c}duckdb already installed.${r}"
fi
