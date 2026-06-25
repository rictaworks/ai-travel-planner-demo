# API 仕様書

ベース URL（開発）: `http://localhost:3001`
ベース URL（本番）: `https://api-ai-travel-planner.rictaworks.jp`

認証: なし（デモ版）。セッション Cookie (`owner_session_id`) を使用。

---

## POST /itineraries

旅程を生成して保存する。

### リクエスト

```json
{
  "trip_days": 2,
  "budget_total": 10000,
  "preferences": [
    { "category": "grourmet", "priority": 1 },
    { "category": "nature", "priority": 2 }
  ],
  "expected_weather": "sunny",
  "honeypot": ""
}
```

| フィールド | 型 | 必須 | 説明 |
|---|---|---|---|
| `trip_days` | integer | yes | 旅行日数（1〜3） |
| `budget_total` | integer | yes | 予算総額（円、0 より大） |
| `preferences` | array | no | 好みカテゴリと優先順位。空配列可（全カテゴリ等重み） |
| `expected_weather` | string | yes | `sunny` / `cloudy` / `rainy` / `snowy` |
| `honeypot` | string | yes | Bot 対策用非表示フィールド（値が入っていれば 422 を返す） |

### レスポンス（成功）

```json
{
  "id": 1,
  "status": "generated",
  "trip_days": 2,
  "budget_total": 10000,
  "expected_weather": "sunny",
  "days": [
    {
      "day_number": 1,
      "items": [
        {
          "spot_id": 3,
          "spot_name": "浅草寺",
          "category": "historical",
          "time_slot": "morning",
          "cost": 500,
          "duration_min": 90
        }
      ]
    }
  ]
}
```

### レスポンス（エラー）

```json
{
  "error": "no_plan_available",
  "message": "予算内で提案可能なプランがありません"
}
```

| HTTP ステータス | 意味 |
|---|---|
| 201 | 旅程生成成功 |
| 422 | バリデーションエラー（ハニーポット検知含む） |
| 400 | 予算内で選定不可 |

---

## GET /itineraries/:id

旅程を取得する。他のセッションの旅程は取得不可（`owner_session_id` でスコーピング）。

### レスポンス（成功）

POST /itineraries の成功レスポンスと同形式。

| HTTP ステータス | 意味 |
|---|---|
| 200 | 取得成功 |
| 404 | 旅程が存在しないまたはセッション不一致 |
