<?php
// DB接続情報は環境変数から取得する。本番の認証情報をこのファイルに直接書かないこと。
return [
    'db' => [
        'host' => getenv('DB_HOST') ?: '127.0.0.1',
        'port' => getenv('DB_PORT') ?: '3306',
        'name' => getenv('DB_NAME') ?: 'towncircle',
        'user' => getenv('DB_USER') ?: 'root',
        'pass' => getenv('DB_PASS') ?: '',
    ],
    // 一定時間操作がない場合の自動ログアウトに対応するトークン有効期限（分）
    // 認証済みリクエストのたびに延長される（スライド式セッション）
    'token_ttl_minutes' => (int) (getenv('TOKEN_TTL_MINUTES') ?: 30),
];
