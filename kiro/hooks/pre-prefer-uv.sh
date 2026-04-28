#!/usr/bin/env bash
# preToolUse hook: Python ツールに uv を推奨（実行は許可）
# matcher: "shell"

INPUT=$(cat)
CMD=$(printf '%s' "$INPUT" | grep -oP '"command"\s*:\s*"\K[^"]*')
[ -z "$CMD" ] && exit 0

has_cmd() {
  printf '%s' "$CMD" | grep -qP '(?:^|&&|\|\||[;|])\s*(?:sudo\s+)?\b'"$1"'\b'
}

if has_cmd 'pip3?'; then
  echo "Blocked: Use 'uv add <pkg>' (project) or 'uv pip install <pkg>' instead of pip." >&2
elif has_cmd 'python3?'; then
  echo "Blocked: Use 'uv run' instead of python. Example: uv run script.py, uv run pytest" >&2
else
  exit 0
fi

exit 2
