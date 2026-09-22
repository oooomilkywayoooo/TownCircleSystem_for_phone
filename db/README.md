# データベース設計

`schema.sql` はMySQL 8.0 / InnoDB / utf8mb4を想定したテーブル定義です。管理者画面（PHP）・一般会員アプリ（Flutter）双方のモックで使ってきたダミーデータをそのまま反映できる構成にしています。

ローカルの一時MySQLインスタンスに実際に流し込み、`CREATE TABLE`・外部キー制約・想定クエリ（役職一覧、ゴミ当番の担当者取得、回覧板既読数集計、組長とのチャット取得）まで動作確認済みです。

## テーブル一覧

| テーブル | 内容 |
|---|---|
| `admins` | 管理者アカウント |
| `member_groups` | 組（1組/2組/3組）。`groups`はMySQLの予約語のためこの名前にしています |
| `members` | 一般会員。`role`（none/leader/vice_leader）で組長・副組長を表現 |
| `member_auth_tokens` | 会員アプリのログイントークン |
| `member_password_resets` | 会員のパスワードリセット申請 |
| `notices` | お知らせ |
| `circulars` / `circular_reads` | 回覧板と既読管理（既読は行の有無で判定） |
| `schedules` | スケジュール |
| `chat_messages` | 全体チャット・組長との個別チャット（下記参照） |
| `garbage_duties` | ゴミ当番（月ごとに会員1人を割り当て） |
| `surveys` | アンケート（Googleフォームのリンク管理） |
| `documents` | 関連資料 |
| `opinions` | ご意見箱 |

## 設計上の主な判断

- **組長・副組長は`member_groups`に持たせない**：`members.role` + `members.group_id`から導出します。組長は毎年ローテーションするため、グループ側に組長IDを持つと異動のたびに二重更新が必要になり不整合の元になります。
- **チャットに`chat_rooms`テーブルは作らない**：`chat_messages.room_type`（`all`/`leader_dm`）と`member_id`（`leader_dm`の場合の相手会員）だけで表現できるため、ルームテーブルを省略しています。送信者は`sender_member_id`（会員本人。組長が送った場合もその人自身のIDが入ります）と`sender_is_admin`（事務局/管理者からの投稿）で判別します。
- **ご意見箱の匿名投稿はDB上でも匿名**：`is_anonymous=1`のときは`member_id`を保存しません。管理者にも投稿者が分からない設計です。
- **ゴミ当番は会員個人単位**：`garbage_duties.member_id`は会員が退会した場合`SET NULL`になり、アプリ側は「未設定」として表示する想定です（Flutter側は実装済み）。
- **会員のログインはトークン方式**：モバイルアプリはブラウザのセッションCookieを使えないため、ログイン時に発行したトークンを`member_auth_tokens`に保存し、以後のAPIリクエストごとに検証します。管理者はブラウザなのでPHPセッションで十分と考え、DBテーブルは用意していません。

## 未確定・次に決めること

1. **PHPとFlutterをつなぐAPI層**：管理者画面（PHP）はこのDBに直接接続できますが、Flutterアプリは直接接続できないためJSON APIが必要です。既存の`admin/`とは別に`api/`のようなエンドポイント群を作るか、管理者側もAPI経由に統一するかは未決定です。
2. **画像・PDFの保存先**：`circulars.image_path` / `documents.file_path`は相対パス文字列を想定していますが、サーバー内ディスクかクラウドストレージかは未決定です。
3. **投入用シードデータ**：動作確認に使ったINSERT文は一時DB上でのみ実行し、リポジトリには含めていません。必要であれば`seed.sql`として追加できます。
