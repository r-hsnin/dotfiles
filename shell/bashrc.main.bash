#!/bin/bash
# bashrc.main.bash — Main shell configuration (loaded in all environments)

# --- History ---
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s checkwinsize

# --- PATH (deduplicated) ---
_add_path() { [[ ":$PATH:" != *":$1:"* ]] && export PATH="$1:$PATH"; }

export BUN_INSTALL="$HOME/.bun"
_add_path "$BUN_INSTALL/bin"
_add_path "$HOME/.local/bin"

# cargo env
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# fnm (if available)
if [[ -d "$HOME/.local/share/fnm" ]]; then
  _add_path "$HOME/.local/share/fnm"
  eval "$(fnm env --use-on-cd --shell bash)"
fi

# deno (if available)
[[ -f "$HOME/.deno/env" ]] && source "$HOME/.deno/env"

# --- Editor ---
export EDITOR=micro

# --- Terminal ---
export COLORTERM=truecolor
export LANG=en_US.UTF-8

# --- Bash completion ---
if ! shopt -oq posix; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
  elif [[ -f /etc/bash_completion ]]; then
    source /etc/bash_completion
  fi
fi

# --- Aliases ---
alias fd='fdfind'
alias bat='batcat'
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first --git'
alias lt='eza --tree --level=3 --icons'

# Yazi: change to directory on exit
y() {
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  cwd="$(command cat -- "$tmp")" && [[ -n "$cwd" ]] && [[ "$cwd" != "$PWD" ]] && builtin cd -- "$cwd" || true
  rm -f -- "$tmp"
}

# --- fzf ---
if [[ -d "$HOME/.fzf/bin" ]]; then
  _add_path "$HOME/.fzf/bin"
fi
export FZF_CTRL_T_OPTS="--walker-skip .git,node_modules,target --preview 'batcat -n --color=always {}'"
export FZF_ALT_C_OPTS="--walker-skip .git,node_modules,target --preview 'tree -C {}'"

# --- zoxide ---
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init bash)"
fi

# --- oh-my-posh ---
if command -v oh-my-posh &>/dev/null; then
  eval "$(oh-my-posh init bash --config "$HOME/.config/oh-my-posh/theme.omp.json")"
fi

# --- tmux auto-attach on interactive SSH ---
if [[ $- == *i* ]] && [[ -n "${SSH_CONNECTION:-}" ]] && [[ -z "${TMUX:-}" ]] \
   && [[ "${TERM_PROGRAM:-}" != "vscode" ]] && command -v tmux &>/dev/null; then
  exec tmux new-session -A -s main
fi

# --- Environment-specific ---
DOTFILES_DIR="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

if [[ "${CODESPACES:-}" == "true" ]]; then
  [[ -f "$DOTFILES_DIR/shell/bashrc.codespaces.bash" ]] && source "$DOTFILES_DIR/shell/bashrc.codespaces.bash"
elif [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
  [[ -f "$DOTFILES_DIR/shell/bashrc.wsl.bash" ]] && source "$DOTFILES_DIR/shell/bashrc.wsl.bash"
fi

# --- ble.sh (with fallback) ---
if [[ -z "${BLE_SKIP:-}" ]] && [[ -f "$HOME/.local/share/blesh/ble.sh" ]]; then
  [[ -f "$DOTFILES_DIR/shell/bashrc.ble.bash" ]] && source "$DOTFILES_DIR/shell/bashrc.ble.bash"
else
  # fzf keybindings for non-ble.sh sessions
  if command -v fzf &>/dev/null; then
    eval "$(fzf --bash 2>/dev/null)" || true
  fi
fi
