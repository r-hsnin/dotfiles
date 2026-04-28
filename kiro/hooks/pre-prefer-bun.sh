#!/usr/bin/env bash
# preToolUse hook: JS ツールに bun を推奨（実行は許可）
# matcher: "shell"

INPUT=$(cat)
CMD=$(printf '%s' "$INPUT" | grep -oP '"command"\s*:\s*"\K[^"]*')
[ -z "$CMD" ] && exit 0

has_cmd() {
  printf '%s' "$CMD" | grep -qP '(?:^|&&|\|\||[;|])\s*(?:sudo\s+)?\b'"$1"'\b'
}

if has_cmd npm; then
  echo "Blocked: Use 'bun add' instead of 'npm install'." >&2
elif has_cmd npx; then
  echo "Blocked: Use 'bunx' instead of 'npx'." >&2
elif has_cmd pnpm; then
  echo "Blocked: Use 'bun' instead of 'pnpm'." >&2
elif has_cmd yarn; then
  echo "Blocked: Use 'bun' instead of 'yarn'." >&2
elif has_cmd node; then
  echo "Blocked: Use 'bun' instead of 'node'." >&2
else
  exit 0
fi

exit 2
