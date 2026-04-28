# Git ワークフロー

## コミットメッセージ形式

```
<type>: <description>

<optional body>
```

Types: feat, fix, refactor, docs, test, chore, perf, ci

- description は日本語で書く
- body は任意。変更理由や背景を補足する場合に使う

## コミットの粒度

- 1コミット = 1つの論理的変更
- 動作する状態でコミット（ビルドが壊れた状態でコミットしない）
- 大きな変更は段階的にコミット

## Pull Request

1. `git diff <base-branch>...HEAD` で全変更を確認
2. 包括的なPRサマリーを作成
3. 新しいブランチの場合は `-u` フラグでpush
