# What are the sonarcloud issues?
# Line 5: echo -e "\033[38;2;255;126;219m[\033[38;2;54;249;246m2026-setup\033[38;2;255;126;219m]\033[0m $1"
# -> echo -e is not posix standard, or could be a security/style issue. It recommends using printf instead.
# Line 9 proto: curl -fsSL https://moonrepo.dev/install/proto.sh | /usr/bin/env bash -> should be `/usr/bin/env sh` based on memory? Wait, memory states:
# "When piping `curl` installation scripts directly to a shell in automated installer modules (e.g., `moon`, `pkgx`, `distrobox`, `deno`), the output should be piped to `/usr/bin/env sh` rather than `bash` or `sh` to prevent blocking the interactive session during automated script execution."
# I'll update proto to pipe to `/usr/bin/env sh`.
# For line 5, I will switch `echo -e` to `printf` or just copy exactly how `setup-2026.sh` does it. Let's see how `setup-2026.sh` handles logging.
