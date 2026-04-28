#!/usr/bin/env bash
# stop hook: 応答完了時に変更ファイルの console.log 残存チェック
# matcher なし（stop hook）
# テスト・設定・scripts/ は除外

cat > /dev/null  # stdin 消費（hook 仕様）

git rev-parse --is-inside-work-tree > /dev/null 2>&1 || exit 0

FILES=$(git diff --name-only --diff-filter=ACM HEAD 2>/dev/null \
  | grep -E '\.[jt]sx?$' \
  | grep -vE '\.(test|spec)\.[jt]sx?$|\.config\.[jt]s$|scripts/|__tests__/')

[ -z "$FILES" ] && exit 0

FOUND=""
while IFS= read -r f; do
  [ -f "$f" ] || continue
  MATCHES=$(grep -nP 'console\.log' "$f" 2>/dev/null | head -10)
  [ -n "$MATCHES" ] && while IFS= read -r line; do
    FOUND="${FOUND}  ${f}:${line}"$'\n'
  done <<< "$MATCHES"
done <<< "$FILES"

if [ -n "$FOUND" ]; then
  echo "[Hook] console.log found in modified files:" >&2
  printf '%s' "$FOUND" | head -10 | while IFS= read -r l; do echo "$l" >&2; done
  echo "[Hook] Remove before committing" >&2
  exit 1
fi
