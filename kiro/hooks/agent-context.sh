#!/usr/bin/env bash
# agentSpawn hook: エージェント起動時にプロジェクトコンテキストを収集
# STDOUTがコンテキストとしてLLMに渡される

echo "=== Project Context ==="
echo "Dir: $(pwd)"
echo "Date: $(date '+%Y-%m-%d %H:%M')"
echo ""

# Git情報
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  BRANCH=$(git branch --show-current 2>/dev/null)
  echo "Branch: ${BRANCH:-$(git rev-parse --short HEAD 2>/dev/null) (detached)}"
  echo ""
  echo "=== Recent Commits ==="
  git log --oneline -5 2>/dev/null
  echo ""
  echo "=== Git Status ==="
  git status --short 2>/dev/null
fi
