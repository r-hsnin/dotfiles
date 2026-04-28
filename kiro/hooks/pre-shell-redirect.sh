#!/usr/bin/env bash
# preToolUse hook: PowerShell/cmd を正しいパスにリダイレクト（ブロック）
# matcher: "shell"

INPUT=$(cat)
CMD=$(printf '%s' "$INPUT" | grep -oP '"command"\s*:\s*"\K[^"]*')
[ -z "$CMD" ] && exit 0

has_cmd() {
  printf '%s' "$CMD" | grep -qP '(?:^|&&|\|\||[;|])\s*(?:sudo\s+)?\b'"$1"'\b'
}

if has_cmd 'powershell(?:\.exe)?' || has_cmd 'pwsh(?:\.exe)?' || has_cmd 'cmd(?:\.exe)?'; then
  PWSH=$(command -v pwsh.exe 2>/dev/null)
  [ -z "$PWSH" ] && [ -x "/mnt/c/Program Files/PowerShell/7/pwsh.exe" ] && PWSH="/mnt/c/Program Files/PowerShell/7/pwsh.exe"
  if [ -n "$PWSH" ]; then
    echo "Use '$PWSH' -Command \"...\" instead." >&2
  else
    echo "Find pwsh: find /mnt/c/Program\\ Files/PowerShell -name pwsh.exe 2>/dev/null" >&2
  fi
  exit 2
fi

exit 0
