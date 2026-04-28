#!/usr/bin/env bash
# preToolUse hook: shell コマンド実行前のガード
# matcher: "shell" で使用
#
# --no-verify フラグ検出 → exit 2 でブロック

INPUT=$(cat)

if printf '%s' "$INPUT" | grep -q -- '--no-verify'; then
  echo "[Hook] --no-verify is blocked. Pre-commit/push hooks must not be skipped." >&2
  exit 2
fi
