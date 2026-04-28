# TypeScript コーディングスタイル

> [common/coding-style.md](../common/coding-style.md) を拡張

## 型

- エクスポートされた関数にはパラメータ型と戻り値型を明示
- ローカル変数の自明な型は推論に任せる
- 繰り返されるインラインオブジェクト型は名前付き型に抽出

## interface vs type

- `interface`: 拡張・実装される可能性のあるオブジェクト型
- `type`: union、intersection、tuple、mapped types、utility types
- `enum` より文字列リテラルunionを優先

## any 禁止

- アプリケーションコードで `any` を使わない
- 外部入力には `unknown` を使い、安全にナローイング
- 呼び出し元に依存する型にはジェネリクス

## React Props

- コンポーネントpropsは名前付き interface/type で定義
- コールバックpropsは明示的に型付け
- `React.FC` は使わない

## イミュータビリティ

```typescript
// WRONG
function update(user: User, name: string): User {
  user.name = name
  return user
}

// CORRECT
function update(user: Readonly<User>, name: string): User {
  return { ...user, name }
}
```

## 入力検証

```typescript
import { z } from 'zod'

const schema = z.object({
  email: z.string().email(),
  age: z.number().int().min(0).max(150),
})

type Input = z.infer<typeof schema>
```
