# API仕様

一般会員向けFlutterアプリ（`mobile/`）専用のJSON APIです。管理者画面（`admin/`）はブラウザから直接MySQLに接続するため、このAPIは経由しません。

## アーキテクチャの判断

- **なぜ管理者側は含めないのか**：管理者画面はサーバーサイドレンダリングのPHPで、同じサーバー上のMySQLに直接アクセスできます。JSON APIを経由させる理由がないため、`admin/`は今まで通りDBに直接クエリを投げる想定です。
- **なぜAPIが必要なのか**：Flutterアプリ（iOS/Android）はMySQLに直接接続できないため、HTTPのJSON APIが必要です。
- **ルーティング**：フレームワークを使わず、`admin/`と同じ「1画面＝1PHPファイル」の考え方で「1エンドポイント＝1PHPファイル」にしています（例: `v1/notices.php`）。URLは`?id=1`のようなクエリ文字列で対象を指定します（`admin/notice_form.php?id=1`と同じ流儀）。
- **レスポンス形式**：常に`{ "data": ..., "error": null }`または`{ "data": null, "error": { "code": "...", "message": "..." } }`のJSONを返します。
- **認証**：一般会員はモバイルアプリのためセッションCookieが使えず、ログイン時に発行したトークンを`Authorization: Bearer <token>`ヘッダーで送る方式にしています。トークンはDBにはSHA-256でハッシュ化して保存し、生の値はログインレスポンスでのみ返します。認証つきリクエストのたびに有効期限を延長する「スライド式」にしており、README記載の「一定時間操作がない場合、自動ログアウト」に対応します（`api/config.php`の`token_ttl_minutes`、既定30分）。

## 動作確認

`db/schema.sql`と同様、一時的なMySQLインスタンス＋PHP内蔵サーバーを使って以下を実際に確認済みです（本番のMySQL・リポジトリには影響していません）。

- 新規登録 → ログイン → トークン取得 → 認証つきAPI呼び出し
- 誤ったパスワードでのログイン・情報変更が401で拒否されること
- 未認証アクセスが401で拒否されること
- メールアドレス重複が409、必須項目未入力・パスワード短すぎが422で拒否されること
- 許可されていないHTTPメソッドが405で拒否されること
- 回覧板の既読化で`is_read`が0→1に変わること、月フィルターが正しく絞り込むこと
- パスワードリセット申請が、登録済み/未登録メールアドレスどちらでも同じレスポンスを返すこと
- スケジュールの月フィルターが正しく絞り込むこと
- 全体チャット・組長とのチャットへの投稿がそれぞれの`room_type`で正しく保存・取得できること、空メッセージが422で拒否されること
- ご意見箱で`is_anonymous:true`の投稿がDB上も`member_id`がNULLで保存されること（named投稿は`member_id`が入ること）
- 組長用受信箱：自組メンバー一覧が返り、他組のメンバー・メッセージが混ざらないこと。最新発言が本人以外なら`needs_reply:true`、組長が返信すると`false`に変わること
- 組長が`chat_leader.php?member_id=`で指定メンバーのスレッドを読み書きできること、他組メンバーを指定すると403になること
- 一般会員が`chat_leader.php?member_id=`で他人のスレッドを開こうとすると403、`chat_leader_inbox.php`を呼ぶと403になること（組長専用）

## エンドポイント一覧

全エンドポイント実装・検証済みです。

| メソッド | パス | 認証 | 内容 |
|---|---|---|---|
| POST | `/v1/auth/register.php` | 不要 | 新規登録 |
| POST | `/v1/auth/login.php` | 不要 | ログイン。トークンを発行 |
| POST | `/v1/auth/password_reset_request.php` | 不要 | パスワードリセットのメール送信申請（登録有無に関わらず同じレスポンス） |
| GET | `/v1/groups.php` | 不要 | 組一覧（新規登録画面のグループ選択用） |
| GET | `/v1/me.php` | 必要 | 会員情報取得（会員情報変更画面のプリフィル用） |
| PUT | `/v1/me.php` | 必要 | 会員情報変更（`current_password`必須。パスワード自体を変える場合のみ`new_password`を追加） |
| GET | `/v1/notices.php` | 必要 | お知らせ一覧 |
| GET | `/v1/circulars.php?month=YYYY-MM` | 必要 | 回覧板一覧（`is_read`つき、`month`省略で全件） |
| POST | `/v1/circular_read.php?id={id}` | 必要 | 回覧板を既読にする |
| GET | `/v1/schedules.php?month=YYYY-MM` | 必要 | スケジュール一覧（`month`省略で全件） |
| GET | `/v1/chat_all.php` | 必要 | 町内会全体チャットの取得 |
| POST | `/v1/chat_all.php` | 必要 | 町内会全体チャットへの投稿 |
| GET | `/v1/chat_leader.php[?member_id=]` | 必要 | 組長との個別チャット取得。`member_id`省略時は自分自身のスレッド、組長が指定する場合は下記参照 |
| POST | `/v1/chat_leader.php[?member_id=]` | 必要 | 組長への送信、または組長からの返信 |
| GET | `/v1/chat_leader_inbox.php` | 必要（組長のみ） | 組長用受信箱：自組メンバー一覧＋各メンバーとの最新メッセージ・未返信フラグ |
| GET | `/v1/garbage_duties.php` | 必要 | ゴミ当番一覧（会員個人単位） |
| GET | `/v1/surveys.php` | 必要 | アンケート一覧（Googleフォームリンク） |
| GET | `/v1/documents.php` | 必要 | 関連資料一覧 |
| POST | `/v1/opinions.php` | 必要\* | ご意見送信。`is_anonymous:true`のときはサーバー側で`member_id`を保存しない |

\* 送信自体はログイン済み会員のみだが、匿名フラグによりDB上は投稿者を特定できなくする。

### 組長用受信箱（`chat_leader.php` / `chat_leader_inbox.php`）

一般会員・副組長は`chat_leader.php`を`member_id`なしで呼び、常に「自分自身と自組の組長」とのスレッドを読み書きする。

組長は追加で2つの操作ができる。
1. `GET /v1/chat_leader_inbox.php` で自組メンバー一覧を取得する。各メンバーに`last_message` `last_message_at` `needs_reply`が付き、`needs_reply`は「そのスレッドの最新メッセージが組長自身の発言でないか」で判定する（既読テーブルは持たない近似）。
2. `chat_leader.php?member_id={対象会員id}` を指定して、選んだメンバーとのスレッドを読み書きする。対象は自分と同じ組の会員に限り、他の組の会員を指定すると403になる。組長以外がこのパラメータを使おうとした場合も403。

Flutter側は`mobile/lib/screens/leader_inbox_screen.dart`（一覧）と`leader_chat_detail_screen.dart`（個別チャット）で対応する。`CurrentUser.role`が`'leader'`のときだけチャット画面の2つ目のタブが「組長とのチャット」から「メンバー対応」に切り替わる（`mobile/lib/data/mock_data.dart`）。

## レスポンス例

**ログイン成功**
```json
{
  "data": {
    "token": "生成された64文字のトークン",
    "member": { "id": 1, "name": "鈴木 花子", "group_id": 2, "role": "none" }
  },
  "error": null
}
```

**エラー（例: パスワード不一致）**
```json
{ "data": null, "error": { "code": "INVALID_PASSWORD", "message": "現在のパスワードが正しくありません" } }
```

## ローカルでの動かし方

```bash
DB_HOST=127.0.0.1 DB_PORT=3306 DB_NAME=towncircle DB_USER=root DB_PASS=yourpassword \
  php -S localhost:8099 -t api
```

Flutter側からは`http`パッケージ等で`http://<ホスト>:8099/v1/...`を呼び出し、ログインで得たトークンを`flutter_secure_storage`等に保存して以後のリクエストヘッダーに付与する想定です（現状の`mobile/`はまだ`mock_data.dart`のダミーデータのままで、API接続は未実装です）。

## 未確定・次に決めること

1. Flutter側の実際のHTTP通信化（`http`パッケージ導入、トークン保存、エラーハンドリングのUI反映）
2. 管理者画面（PHP）側のDB接続実装（`admin/`の各画面のダミー配列を実クエリに置き換える）
3. 画像・PDFアップロードの実装（`circulars.image_path` / `documents.file_path`の保存先確定）
4. 本番のCORS設定（現状`Access-Control-Allow-Origin: *`は開発用）
5. 組長用の受信箱機能（複数会員とのチャットスレッドを一覧・返信する画面とAPI）
