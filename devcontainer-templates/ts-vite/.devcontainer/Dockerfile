FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG USERNAME=vscode

# --- System packages + ble.sh (single layer, remove build deps after) ---
RUN apt-get update && apt-get install -y --no-install-recommends \
    ripgrep fd-find bat fzf jq tree tmux curl unzip \
    build-essential gawk \
    && ln -sf /usr/bin/batcat /usr/local/bin/bat \
    && ln -sf /usr/bin/fdfind /usr/local/bin/fd \
    # ble.sh (build then remove build deps)
    && git clone --recursive --depth 1 https://github.com/akinomyoga/ble.sh.git /tmp/ble.sh \
    && make -C /tmp/ble.sh install PREFIX=/home/${USERNAME}/.local \
    && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.local \
    && rm -rf /tmp/ble.sh \
    && apt-get purge -y build-essential gawk && apt-get autoremove -y \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# --- Tools without features (zoxide, sd) ---
RUN set -eux \
    && curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh -s -- --bin-dir /usr/local/bin \
    && SD_VERSION=$(curl -s https://api.github.com/repos/chmln/sd/releases/latest | jq -r '.tag_name') \
    && curl -fsSL "https://github.com/chmln/sd/releases/download/${SD_VERSION}/sd-${SD_VERSION}-x86_64-unknown-linux-gnu.tar.gz" \
       | tar xz --strip-components=1 -C /usr/local/bin/ --wildcards '*/sd'

# --- User-level tools (no feature available) ---
USER ${USERNAME}

# fnm + Node.js
RUN curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.local/share/fnm" --skip-shell \
    && export PATH="$HOME/.local/share/fnm:$PATH" \
    && eval "$(fnm env)" \
    && fnm install 22 && fnm default 22

# kiro-cli
RUN curl -fsSL https://cli.kiro.dev/install | bash
