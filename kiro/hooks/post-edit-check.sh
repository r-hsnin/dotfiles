#!/usr/bin/env bash
# postToolUse hook: 編集後に自動チェック（format + lint）
# matcher: "write" で使用
#
# JS/TS: biome > prettier（単一ファイル高速処理を優先）
# Python: ruff > black

INPUT=$(cat)
FILE_PATH=$(printf '%s' "$INPUT" | grep -oP '"path"\s*:\s*"\K[^"]*')
[ -z "$FILE_PATH" ] && exit 0

# 対象拡張子チェック
case "$FILE_PATH" in
  *.ts|*.tsx|*.js|*.jsx|*.json|*.jsonc|*.md|*.css|*.py) ;;
  *) exit 0 ;;
esac

ABS=$(realpath -m "$FILE_PATH" 2>/dev/null || echo "$FILE_PATH")
[ -f "$ABS" ] || exit 0

# プロジェクトルート検出
find_root() {
  local dir=$1
  while [ "$dir" != "/" ]; do
    [ -f "$dir/package.json" ] || [ -f "$dir/pyproject.toml" ] && { echo "$dir"; return; }
    dir=$(dirname "$dir")
  done
}

ROOT=$(find_root "$(dirname "$ABS")")
[ -z "$ROOT" ] && exit 0

run_tool() {
  local t=$1; shift
  timeout "$t" "$@" 2>&1 | while IFS= read -r line; do [ -n "$line" ] && echo "[Hook] $line" >&2; done
  return 0
}

# Python ツール検出: ruff > black（全候補を探してから実行）
find_py_tool() {
  local name=$1
  for vd in .venv venv; do
    [ -x "$ROOT/$vd/bin/$name" ] && { echo "$ROOT/$vd/bin/$name"; return; }
  done
  command -v "$name" > /dev/null 2>&1 && { echo "$name"; return; }
}

if [[ "$FILE_PATH" == *.py ]]; then
  RUFF=$(find_py_tool ruff)
  [ -n "$RUFF" ] && { run_tool 15 "$RUFF" format "$ABS"; run_tool 15 "$RUFF" check --fix "$ABS"; exit 0; }
  BLACK=$(find_py_tool black)
  [ -n "$BLACK" ] && { run_tool 15 "$BLACK" --quiet "$ABS"; exit 0; }
  exit 0
fi

# JS/TS: biome > prettier
BIN="$ROOT/node_modules/.bin"

for cfg in biome.json biome.jsonc; do
  [ -f "$ROOT/$cfg" ] && [ -x "$BIN/biome" ] && { run_tool 15 "$BIN/biome" check --write "$ABS"; exit 0; }
done

for cfg in .prettierrc .prettierrc.json .prettierrc.js .prettierrc.cjs .prettierrc.mjs .prettierrc.yml .prettierrc.yaml prettier.config.js prettier.config.cjs prettier.config.mjs; do
  [ -f "$ROOT/$cfg" ] && [ -x "$BIN/prettier" ] && { run_tool 15 "$BIN/prettier" --write "$ABS"; exit 0; }
done

exit 0
