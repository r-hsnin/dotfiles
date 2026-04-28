#!/bin/bash
# install/codespaces.sh — Codespaces-specific setup
# Tools are pre-installed via Dockerfile; this handles config only.
# Token handling is done dynamically in bashrc.codespaces.bash (not here).
set -euo pipefail

echo "--- codespaces setup ---"
echo "  Token: handled dynamically by bashrc.codespaces.bash"
echo "--- codespaces setup done ---"
