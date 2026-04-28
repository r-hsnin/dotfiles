# Python コーディングスタイル

> [common/coding-style.md](../common/coding-style.md) を拡張

## 標準

- PEP 8 に従う
- すべての関数シグネチャに型注釈

## イミュータビリティ

```python
from dataclasses import dataclass

@dataclass(frozen=True)
class User:
    name: str
    email: str
```

## フォーマット・リント

- **ruff**: リント + フォーマット（推奨）
- **black**: コードフォーマット
- **isort**: import整理

## 入力検証

```python
from pydantic import BaseModel

class UserInput(BaseModel):
    email: str
    age: int
```
