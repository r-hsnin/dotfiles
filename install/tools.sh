#!/bin/bash
# install/tools.sh — Install tools for local WSL2 environment
# Codespaces uses Dockerfile instead; this is for local only.
set -euo pipefail

echo "--- tools (WSL2 local) ---"

has() { command -v "$1" &>/dev/null; }

# ble.sh
if [[ ! -d "$HOME/.local/share/blesh" ]]; then
  echo "  installing ble.sh..."
  git clone --recursive --depth 1 https://github.com/akinomyoga/ble.sh.git /tmp/ble.sh
  make -C /tmp/ble.sh install PREFIX="$HOME/.local"
  rm -rf /tmp/ble.sh
fi

# oh-my-posh
if ! has oh-my-posh; then
  echo "  installing oh-my-posh..."
  curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME/.local/bin"
fi

# fzf
if ! has fzf; then
  echo "  installing fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
  "$HOME/.fzf/install" --bin --no-update-rc --no-completion
fi

# zoxide
if ! has zoxide; then
  echo "  installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

echo "--- tools done ---"
