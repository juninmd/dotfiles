#!/bin/sh
# Downloads the dotfiles installer for this OS/arch and verifies its SHA-256 before running.
set -eu
REL="https://github.com/juninmd/dotfiles/releases/latest/download"
case "$(uname -s)" in Linux) os=linux ;; Darwin) os=macos ;; *) echo "unsupported OS" >&2; exit 1 ;; esac
case "$(uname -m)" in x86_64|amd64) arch=x64 ;; arm64|aarch64) arch=arm64 ;; *) echo "unsupported arch" >&2; exit 1 ;; esac
name="dotfiles-$os-$arch"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
curl -fsSL "$REL/$name" -o "$tmp/$name"
curl -fsSL "$REL/SHA256SUMS" -o "$tmp/SHA256SUMS"
want="$(grep " $name\$" "$tmp/SHA256SUMS" | cut -d' ' -f1)"
[ -n "$want" ] || { echo "no checksum for $name" >&2; exit 1; }
if command -v sha256sum >/dev/null 2>&1; then got="$(sha256sum "$tmp/$name" | cut -d' ' -f1)"; else got="$(shasum -a 256 "$tmp/$name" | cut -d' ' -f1)"; fi
[ "$want" = "$got" ] || { echo "checksum mismatch" >&2; exit 1; }
chmod +x "$tmp/$name"
"$tmp/$name" "$@"
