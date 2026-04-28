# dotfiles

GitHub Codespaces（SSH 接続）+ WSL2 ローカル環境向けの dotfiles。

## セットアップ

### Codespaces

1. GitHub Settings → Codespaces → Dotfiles でこのリポジトリを指定
2. `gh codespace create` で Codespace を作成
3. `gh codespace ssh` で接続（自動で tmux セッションにアタッチ）

### WSL2 ローカル

```bash
git clone https://github.com/r-hsnin/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

## 構成

```
dotfiles/
├── install.sh                    # エントリポイント
├── install/
│   ├── symlinks.sh               # シンボリックリンク作成
│   ├── tools.sh                  # WSL2 用ツールインストール
│   └── codespaces.sh             # Codespaces 固有設定
├── shell/
│   ├── bashrc.main.bash          # メインシェル設定
│   ├── bashrc.ble.bash           # ble.sh 統合
│   ├── bashrc.wsl.bash           # WSL2 固有
│   ├── bashrc.codespaces.bash    # Codespaces 固有
│   ├── .blerc                    # ble.sh 設定
│   └── .inputrc                  # Readline 設定
├── git/
│   └── .gitconfig.tmpl           # Git 設定テンプレート
├── config/
│   ├── oh-my-posh/theme.omp.json # Tokyo Night プロンプト
│   ├── tmux/tmux.conf            # tmux 設定
│   └── yazi/                     # ファイラ設定
├── kiro/                         # kiro-cli 設定
│   ├── settings/
│   ├── hooks/
│   ├── steering/
│   └── agents/
└── devcontainer-templates/
    └── ts-vite/                  # TypeScript + Vite テンプレート
```

## ターミナルスタック

| ツール | 用途 |
|---|---|
| bash + ble.sh | シェル + 補完・ハイライト |
| oh-my-posh | プロンプト（Tokyo Night） |
| tmux | セッション永続化 |
| fzf | ファジー検索 |
| zoxide | スマート cd |
| eza | ls 代替 |
| batcat | cat 代替 |
| delta | git diff |
| lazygit | TUI git |
| yazi | ファイラ |
| micro | エディタ |
| ripgrep / fd | 検索 |
| kiro-cli | AI コーディング |

## 環境分岐

`$CODESPACES` と `/proc/sys/fs/binfmt_misc/WSLInterop` で自動判定。

- **Codespaces**: ツールは Dockerfile で事前インストール。dotfiles は設定注入のみ
- **WSL2**: `install/tools.sh` でツールをインストール

## ble.sh フォールバック

問題が出た場合は `export BLE_SKIP=1` で無効化可能。oh-my-posh は ble.sh なしでも動作する。

## SSH ポートフォワーディング

`forwardPorts` は VS Code 専用。SSH 接続時は手動でフォワードする：

```bash
# 別ターミナルで実行
gh codespace ports forward 5173:5173 -c <codespace-name>

# または SSH の -L フラグ
gh codespace ssh -c <name> -- -L 5173:localhost:5173 -L 4242:localhost:4242
```

## kiro skills について

`kiro/skills/` は容量が大きいため、このリポジトリには含めていない。必要に応じて別途コピーまたはシンボリックリンクで追加する。

## devcontainer テンプレートの使い方

```bash
cp -r ~/dotfiles/devcontainer-templates/ts-vite/.devcontainer .
```
