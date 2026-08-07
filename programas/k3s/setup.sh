#!/bin/bash
echo -e "\e[32mInstalling k3s...\e[0m"
curl -sfL https://get.k3s.io | sh - # NOSONAR
