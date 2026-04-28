#!/bin/bash
# bashrc.wsl.bash — WSL2-specific configuration

# Fix Node.js DNS resolution delay (prioritize IPv4 over IPv6)
export NODE_OPTIONS="--dns-result-order=ipv4first"

# GitHub MCP Server token (only if gh is authenticated)
_gh_token="$(gh auth token 2>/dev/null)"
[[ -n "$_gh_token" ]] && export GITHUB_PERSONAL_ACCESS_TOKEN="$_gh_token"
unset _gh_token
