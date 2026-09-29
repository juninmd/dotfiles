#!/bin/bash
printf "%b\n" "\e[32mInstalling TFLint...\e[0m"
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash # NOSONAR
