# Python パターン

> [common/patterns.md](../common/patterns.md) を拡張

## Protocol（Duck Typing）

```python
from typing import Protocol

class Repository(Protocol):
    def find_by_id(self, id: str) -> dict | None: ...
    def save(self, entity: dict) -> dict: ...
```

## Dataclass DTO

```python
from dataclasses import dataclass

@dataclass
class CreateUserRequest:
    name: str
    email: str
    age: int | None = None
```

## Context Manager

リソース管理には `with` 文を使用。ジェネレータで遅延評価・メモリ効率の良いイテレーション。
