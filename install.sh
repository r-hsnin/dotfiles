#!/bin/bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
export DOTFILES

# --- Environment detection ---
is_codespaces() { [[ "${CODESPACES:-}" == "true" ]]; }
is_wsl() { [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; }

echo "=== dotfiles install ==="
echo "  DOTFILES: $DOTFILES"
echo "  Codespaces: $(is_codespaces && echo yes || echo no)"
echo "  WSL: $(is_wsl && echo yes || echo no)"
echo ""

# 1. Symlinks (always)
source "$DOTFILES/install/symlinks.sh"

# 2. Environment-specific setup
if is_codespaces; then
  source "$DOTFILES/install/codespaces.sh"
elif is_wsl; then
  source "$DOTFILES/install/tools.sh"
fi

echo ""
echo "=== dotfiles install complete ==="
