#!/usr/bin/env bash
# agentSpawn hook: エージェントが使えるツールと使い分けルール
# STDOUTがコンテキストとしてLLMに渡される

cat << 'EOF'
=== Available Tools ===

JS/TS: bun (runtime, package manager, test runner), bunx, deno, fnm
Python: uv run / uv add / uvx (default: 3.14)
Git: git, gh, delta (core.pager)
Cloud: aws
Search: rg, fdfind, fzf
Text: jq, yq, sd
File: eza, tree, batcat
HTTP: curl
Build: make, cargo

=== Tool Rules ===

- node/npm/npx → bun / bunx を使う
- python3/pip → uv run / uv add を使う
- grep → rg を使う
- find → fdfind を使う
- sed → sd を優先（ストリーム処理のみ sed）
- ls → eza を使う
- cat → batcat（ハイライト必要時）
EOF
