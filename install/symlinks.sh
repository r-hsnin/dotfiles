#!/bin/bash
# install/symlinks.sh — Create all symlinks and generated files
set -euo pipefail

echo "--- symlinks ---"

# Helper: create symlink (idempotent, handles existing real directories)
link() {
  local src="$1" dst="$2"
  local dst_dir
  dst_dir="$(dirname "$dst")"
  [[ -d "$dst_dir" ]] || mkdir -p "$dst_dir"
  # ln -sfn can't replace a real directory; remove it first
  [[ -d "$dst" && ! -L "$dst" ]] && rm -rf "$dst"
  ln -sfn "$src" "$dst"
  echo "  $dst -> $src"
}

# --- Shell ---
MARKER="# dotfiles-source"
inject_source() {
  local target="$1" source_file="$2"
  if [[ -f "$target" ]] && grep -q "$MARKER" "$target" 2>/dev/null; then
    return
  fi
  {
    echo ""
    echo "$MARKER"
    echo "[ -f \"$source_file\" ] && source \"$source_file\""
  } >> "$target"
  echo "  injected source into $target"
}

inject_source "$HOME/.bashrc" "$DOTFILES/shell/bashrc.main.bash"
link "$DOTFILES/shell/.inputrc" "$HOME/.inputrc"
link "$DOTFILES/shell/.blerc" "$HOME/.blerc"

# --- Git ---
# .gitconfig is generated from template (paths differ per environment)
GH_PATH="$(command -v gh 2>/dev/null || echo "$HOME/.local/bin/gh")"
sed "s|__GH_PATH__|${GH_PATH}|g" "$DOTFILES/git/.gitconfig.tmpl" > "$HOME/.gitconfig"
echo "  generated ~/.gitconfig (gh: $GH_PATH)"

# --- Config ---
link "$DOTFILES/config/oh-my-posh/theme.omp.json" "$HOME/.config/oh-my-posh/theme.omp.json"
link "$DOTFILES/config/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
link "$DOTFILES/config/yazi" "$HOME/.config/yazi"

# --- Kiro CLI ---
mkdir -p "$HOME/.kiro"
for dir in settings hooks steering agents; do
  if [[ -d "$DOTFILES/kiro/$dir" ]]; then
    link "$DOTFILES/kiro/$dir" "$HOME/.kiro/$dir"
  fi
done

# kiro skills (large, symlink individually only if present)
if [[ -d "$DOTFILES/kiro/skills" ]]; then
  link "$DOTFILES/kiro/skills" "$HOME/.kiro/skills"
fi

echo "--- symlinks done ---"
