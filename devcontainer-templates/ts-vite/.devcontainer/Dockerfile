FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG USERNAME=vscode

# --- System packages ---
RUN apt-get update && apt-get install -y --no-install-recommends \
    ripgrep fd-find bat fzf jq tree tmux curl unzip \
    build-essential \
    && ln -sf /usr/bin/batcat /usr/local/bin/bat \
    && ln -sf /usr/bin/fdfind /usr/local/bin/fd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# --- GitHub release binaries (single layer) ---
RUN set -eux \
    # eza
    && curl -fsSL "$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest | jq -r '.assets[] | select(.name | test("eza_x86_64-unknown-linux-gnu.tar.gz$")) | .browser_download_url')" \
       | tar xz -C /usr/local/bin/ \
    # delta
    && DELTA_VERSION=$(curl -s https://api.github.com/repos/dandavison/delta/releases/latest | jq -r '.tag_name') \
    && curl -fsSL "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-x86_64-unknown-linux-gnu.tar.gz" \
       | tar xz --strip-components=1 -C /usr/local/bin/ --wildcards '*/delta' \
    # zoxide
    && curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh -s -- --bin-dir /usr/local/bin \
    # yq
    && curl -fsSL "$(curl -s https://api.github.com/repos/mikefarah/yq/releases/latest | jq -r '.assets[] | select(.name == "yq_linux_amd64") | .browser_download_url')" \
       -o /usr/local/bin/yq && chmod +x /usr/local/bin/yq \
    # lazygit
    && LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | jq -r '.tag_name' | sed 's/v//') \
    && curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_linux_x86_64.tar.gz" \
       | tar xz -C /usr/local/bin/ lazygit \
    # micro
    && curl -fsSL https://getmic.ro | bash && mv micro /usr/local/bin/ \
    # yazi
    && YAZI_VERSION=$(curl -s https://api.github.com/repos/sxyazi/yazi/releases/latest | jq -r '.tag_name') \
    && curl -fsSL "https://github.com/sxyazi/yazi/releases/download/${YAZI_VERSION}/yazi-x86_64-unknown-linux-gnu.zip" \
       -o /tmp/yazi.zip && unzip -o /tmp/yazi.zip -d /tmp/yazi \
    && mv /tmp/yazi/yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin/ \
    && rm -rf /tmp/yazi /tmp/yazi.zip \
    # oh-my-posh
    && curl -s https://ohmyposh.dev/install.sh | bash -s -- -d /usr/local/bin \
    # sd
    && SD_VERSION=$(curl -s https://api.github.com/repos/chmln/sd/releases/latest | jq -r '.tag_name') \
    && curl -fsSL "https://github.com/chmln/sd/releases/download/${SD_VERSION}/sd-${SD_VERSION}-x86_64-unknown-linux-gnu.tar.gz" \
       | tar xz --strip-components=1 -C /usr/local/bin/ --wildcards '*/sd' \
    # lefthook
    && LEFTHOOK_VERSION=$(curl -s https://api.github.com/repos/evilmartians/lefthook/releases/latest | jq -r '.tag_name' | sed 's/v//') \
    && curl -fsSL "https://github.com/evilmartians/lefthook/releases/download/v${LEFTHOOK_VERSION}/lefthook_${LEFTHOOK_VERSION}_Linux_x86_64" \
       -o /usr/local/bin/lefthook && chmod +x /usr/local/bin/lefthook

# --- ble.sh (pre-built for fast shell startup) ---
RUN git clone --recursive --depth 1 https://github.com/akinomyoga/ble.sh.git /tmp/ble.sh \
    && make -C /tmp/ble.sh install PREFIX=/home/${USERNAME}/.local \
    && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.local \
    && rm -rf /tmp/ble.sh

# --- User-level tools ---
USER ${USERNAME}

# fnm + Node.js
RUN curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.local/share/fnm" --skip-shell \
    && export PATH="$HOME/.local/share/fnm:$PATH" \
    && eval "$(fnm env)" \
    && fnm install 22 && fnm default 22

# bun
RUN curl -fsSL https://bun.sh/install | bash

# uv + Python
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Rust/Cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile minimal

# kiro-cli
RUN curl -fsSL https://cli.kiro.dev/install | bash

# deno
RUN curl -fsSL https://deno.land/install.sh | sh
