# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## 削除系コマンドの禁止（重要）

以下のルールはこのワークスペース内のすべての会話で絶対に守られる：

- Claude はファイルまたはディレクトリを削除するコマンドを一切生成してはならない。
  例：rm, rm -rf, rm *, rmdir, unlink, cache --delete,
      lftp mirror --delete, rsync --delete, git clean -df, find -delete 等。

- 削除が必要な場合でも、Claude は削除コマンドを提案せず、
  「手動で削除してください」といった説明に留めること。

- 削除の推奨・削除操作の自動判断も禁止。

- ssh / lftp / デプロイ系スクリプトを生成する場合でも、
  削除コマンドの生成は禁止。

これらはすべての会話・コード生成に適用される。

---

## ディレクトリ管理

| ディレクトリ | 用途 |
|---|---|
| `TASKS/` | タスク管理（タスク単位でファイル作成） |
| `DEBUG/` | バグ報告（バグ単位でファイル作成） |
| `CLIENT/` | クライアント要望 |
| `WORK/` | 作業報告 |
| `ENV/DEVELOPMENT.md` | 開発環境情報 |
| `ENV/PRODUCTION.md` | 本番環境情報 |
| `SPEC/` | 仕様書・リバースエンジニアリング図（Mermaid） |
| `DELETE/` | ゴミ箱（手動削除前の一時置き場） |
| `app-ui/` | UI モック（実装時はデザイン指定として従うこと） |
| `test/pr***/` | PR 番号ごとのテストスクリプト |

図解は Mermaid 記法で書くこと。

---

## アーキテクチャ

- フロント: Next.js (TypeScript)
- バックエンド: Rails API
- DB: SQLite（デモ版）/ PostgreSQL（本番版）
- 認証: なし（デモ版）/ Google ログイン（本番版）
- 外部 API: 使用しない
- デプロイ: フロント → Vercel（無料）、バックエンド・管理画面 → Railway または Render（無料）
- ドメイン: rictaworks.jp のサブドメイン
- 画像: AI 生成を使用すること

仕様書: @ai-travel-planner-demo-spec.md

規模に応じてマイクロサービスアーキテクチャ・API Gateway・メッセージングを意識すること。
車輪の再発明を避け、安全なライブラリ・OSS・SaaS を活用し、オリジナルコードを少なく保つこと。

---

## ブランチ戦略

- `main` ブランチでの直接作業は禁止。
- `src/*` の変更は必ず PR を作成すること。`src/*` 以外（ドキュメント類）は `main` への直接 push を許可。
- ブランチ命名: `feature/xxx`、`fix/xxx`、`hotfix/xxx`

---

## 開発フロー（TDD 厳守）

順序: **plan → red test → coding → green test**

- バックエンドテスト: RSpec
- フロントユニットテスト: Jest
- E2E・UI 確認: Playwright、curl、`wget --mirror`
- ハードコードを検出するテストを必ず書くこと
- commit 前に必ず `/security-review` を実行すること

---

## 参照ファイル

| ファイル | 内容 |
|---|---|
| @.claude/development-principles.md | 開発原則（YAGNI・KISS・DRY・SOLID） |
| @.claude/TM.md | テスト方法論 |
| @.claude/OWASP10.md | セキュリティ（OWASP Top 10） |
| @.claude/QC10.md | 品質チェック 10 項目 |
| @.claude/CC.md | コンプライアンスチェック 10 項目 |
| @.claude/CRAP.md | デザイン 4 原則 |

---

## セキュリティ・コーディングルール

- グローバル変数禁止（セキュリティ上の理由）。
- 文字列リテラルは設定ファイルまたは DB に分離すること。
- 環境変数は `.env` を参照すること。
- ネイティブの `alert()` / `confirm()` / `prompt()` はプロジェクト全体で使用禁止（UI コンポーネントで代替）。
- 制御構文・条件構文以外はすべてクラスまたは関数に書くこと。
- フォールバック禁止 — 例外処理を確実に実装すること。
- デバッグトレース可能なコードを書くこと（logger を必ず導入する）。
- デフォルトアイコンは FontAwesome を使用すること。絵文字はコード・コメント・UI で禁止。
- ハニーポット方式の Bot 対策を実装すること（@ai-travel-planner-demo-spec.md 参照）。

---

## 多言語対応

7 言語で開発すること: 日本語（ja）、英語（en）、フランス語（fr）、中国語（zh）、ロシア語（ru）、スペイン語（es）、アラビア語（ar）。

管理画面は日本語のみ。

---

## 環境分岐

環境判定を必ず実装し、`development` / `test` / `production` で挙動を分岐すること。

開発環境では認証処理を「認証済み」として扱い、テストを容易にすること。

---

## PR ルール

- PR タイトルと本文は日本語で書くこと。
- PR 本文に非エンジニア向けユーザーテスト手順を丁寧に記載すること。
- PR 作成・確認には `/pr-checker` スキルを使うこと。

---

## エージェントスキル

規模に応じて以下のスキルを起動すること:

| スキル | 役割 |
|---|---|
| `/director` | プロジェクト全体統括 |
| `/project-manager` | タスク・進捗管理（TASKS/ 配下を管理） |
| `/designer` | UI/UX デザイン（CRAP.md・QC10.md 準拠） |
| `/debugger` | デバッグ・トレース解析（DEBUG/ 配下を管理） |
| `/tester` | テストスクリプト生成（test/pr***/ 配下を管理） |
| `/data-scientist` | データ分析・統計 |
| `/deployer` | Vercel / Railway デプロイ |
| `/writer` | 多言語プロフェッショナルライティング |
| `/service-manager` | サービス・インフラ管理 |
| `/pr-checker` | PR を日本語化・ユーザーテスト記載 |
| `/security-review` | commit 前セキュリティレビュー（OWASP10 準拠） |

---

## 補足（未決定の慣例）

- Next.js ポート: 3000（暫定）、Rails API ポート: 3001（暫定）。`.env` で確定すること。
- SPEC/ 配下に仕様書・ER 図・DFD・シーケンス図・クラス図・状態遷移図・ユースケース図を管理・更新すること。
- README.md に自動ログイン説明・ページ一覧・API 一覧を常に最新状態で記載すること。
