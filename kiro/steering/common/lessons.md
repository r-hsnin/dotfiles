# Lessons Learned

個別の知見は `lessons/` ディレクトリに格納。各ファイルには日付・文脈・何が起きたか・なぜ重要か・教訓を記載。

## インデックス

### 大規模改善の実行戦略
- [funnel-dual-use.md](lessons/funnel-dual-use.md) — ファンネルパイプラインの二段活用（計画=視点分散、実行=作業分散）
- [evaluation-agent-mandatory.md](lessons/evaluation-agent-mandatory.md) — 評価エージェントは省略できない（実際にバグを検出した事例）
- [wave-design-constraint-graph.md](lessons/wave-design-constraint-graph.md) — Wave設計は制約グラフから逆算する
- [normalize-base-first.md](lessons/normalize-base-first.md) — 基盤正規化（フォーマッタ等）を最初にやる

### ワークフロー設計
- [merge-ceremony-and-handoff.md](lessons/merge-ceremony-and-handoff.md) — マージ儀式のオーバーヘッドと引き継ぎプロンプト
- [human-intervention-policy-level.md](lessons/human-intervention-policy-level.md) — 人間の介入はポリシーレベルに集中させる

### 反省点
- [agent-context-constraints.md](lessons/agent-context-constraints.md) — エージェントのコンテキスト制約を計画に織り込む

### 定量的知見
- [session-data-quantitative.md](lessons/session-data-quantitative.md) — セッションデータから得た指標（read:write比率、grep使用頻度等）
