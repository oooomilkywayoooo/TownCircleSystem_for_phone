<?php
require_once __DIR__ . '/Database.php';
require_once __DIR__ . '/response.php';

/**
 * Authorization: Bearer <token> を検証し、会員レコードを返す。
 * 不正・期限切れの場合は401を返して終了する。
 * 有効期限はリクエストのたびにスライド延長し、「一定時間操作がない場合の自動ログアウト」を実現する。
 */
function current_member(): array
{
    $header = $_SERVER['HTTP_AUTHORIZATION'] ?? '';
    if (!preg_match('/^Bearer\s+(.+)$/', $header, $m)) {
        json_error('UNAUTHORIZED', '認証トークンがありません', 401);
    }
    $token = hash('sha256', $m[1]);

    $pdo = Database::connection();
    $stmt = $pdo->prepare(
        'SELECT m.* FROM member_auth_tokens t
         JOIN members m ON m.id = t.member_id
         WHERE t.token = :token AND t.expires_at > NOW()'
    );
    $stmt->execute(['token' => $token]);
    $member = $stmt->fetch();

    if (!$member) {
        json_error('UNAUTHORIZED', 'トークンが無効か有効期限切れです', 401);
    }

    $config = require __DIR__ . '/../config.php';
    $update = $pdo->prepare(
        'UPDATE member_auth_tokens SET expires_at = DATE_ADD(NOW(), INTERVAL :ttl MINUTE) WHERE token = :token'
    );
    $update->execute(['ttl' => $config['token_ttl_minutes'], 'token' => $token]);

    return $member;
}
