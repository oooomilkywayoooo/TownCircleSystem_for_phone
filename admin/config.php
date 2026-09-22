<?php
// DB接続情報は環境変数から取得する。本番の認証情報をこのファイルに直接書かないこと。
// 既定値は db/start-mysql.sh で立てるローカル開発用MySQL（ポート3307）に合わせている。
return [
    'db' => [
        'host' => getenv('DB_HOST') ?: '127.0.0.1',
        'port' => getenv('DB_PORT') ?: '3307',
        'name' => getenv('DB_NAME') ?: 'towncircle',
        'user' => getenv('DB_USER') ?: 'root',
        'pass' => getenv('DB_PASS') ?: '',
    ],
    // 一定時間操作がない場合の自動ログアウトまでの分数
    'session_timeout_minutes' => (int) (getenv('ADMIN_SESSION_TIMEOUT_MINUTES') ?: 30),
];
