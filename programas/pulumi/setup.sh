#!/bin/bash
printf "%b\n" "\e[32mInstalling Pulumi...\e[0m"
curl -fsSL https://get.pulumi.com | bash # NOSONAR
