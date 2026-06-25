# AI Travel Planner Demo

旅行日数・予算・想定天気・好みカテゴリを入力すると、ルールベースで旅程を自動生成する Web アプリのデモ版。

---

## 自動ログイン

このデモ版は認証不要です。Cookie のセッション ID のみで端末識別を行います。ブラウザでアクセスするだけで自動的にセッションが発行され、すぐに利用できます。

---

## ページ一覧

| ページ名 | URL |
|---|---|
| トップ / 旅程入力 | [https://ai-travel-planner.rictaworks.jp/](https://ai-travel-planner.rictaworks.jp/) |
| 旅程表示 | [https://ai-travel-planner.rictaworks.jp/itineraries/:id](https://ai-travel-planner.rictaworks.jp/itineraries/:id) |

---

## API 一覧

詳細仕様: [SPEC/api.md](SPEC/api.md)

| タイトル | エンドポイント URL |
|---|---|
| 旅程生成 | `POST /itineraries` |
| 旅程取得 | `GET /itineraries/:id` |

---

## 仕様書

[ai-travel-planner-demo-spec.md](ai-travel-planner-demo-spec.md)
