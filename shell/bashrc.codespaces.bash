#!/bin/bash
# bashrc.codespaces.bash — Codespaces-specific configuration

# GITHUB_PERSONAL_ACCESS_TOKEN (gh is pre-authenticated in Codespaces)
export GITHUB_PERSONAL_ACCESS_TOKEN="${GITHUB_PERSONAL_ACCESS_TOKEN:-$(gh auth token 2>/dev/null)}"
