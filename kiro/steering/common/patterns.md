# 共通パターン

## Skeleton Projects

新機能を実装する前に:
1. 実績のあるスケルトンプロジェクトを検索
2. 最適なものをベースにクローン
3. 実績ある構造の中でイテレーション

## Repository Pattern

データアクセスを一貫したインターフェースの背後にカプセル化:
- 標準操作を定義: findAll, findById, create, update, delete
- 具象実装がストレージの詳細を処理
- ビジネスロジックは抽象インターフェースに依存

## API Response Format

すべてのAPIレスポンスに一貫したエンベロープを使用:
- success/status インジケータ
- data ペイロード（エラー時はnull）
- error メッセージ（成功時はnull）
- ページネーション用メタデータ（total, page, limit）
