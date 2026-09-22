<?php
require_once __DIR__ . '/../../lib/bootstrap.php';

require_method('POST');

$body = json_body();
$email = trim((string) ($body['email'] ?? ''));
$password = (string) ($body['password'] ?? '');

if ($email === '' || $password === '') {
    json_error('VALIDATION_ERROR', 'メールアドレスとパスワードを入力してください', 422);
}

$pdo = Database::connection();
$stmt = $pdo->prepare('SELECT * FROM members WHERE email = :email');
$stmt->execute(['email' => $email]);
$member = $stmt->fetch();

if (!$member || !password_verify($password, $member['password_hash'])) {
    json_error('INVALID_CREDENTIALS', 'メールアドレスまたはパスワードが違います', 401);
}

$config = require __DIR__ . '/../../config.php';
$rawToken = bin2hex(random_bytes(32));
$hashedToken = hash('sha256', $rawToken);

$insert = $pdo->prepare(
    'INSERT INTO member_auth_tokens (member_id, token, expires_at)
     VALUES (:member_id, :token, DATE_ADD(NOW(), INTERVAL :ttl MINUTE))'
);
$insert->execute([
    'member_id' => $member['id'],
    'token' => $hashedToken,
    'ttl' => $config['token_ttl_minutes'],
]);

json_ok([
    // 生トークンはこの応答でのみ渡される。DBにはハッシュ化した値だけを保存する。
    'token' => $rawToken,
    'member' => [
        'id' => (int) $member['id'],
        'name' => $member['name'],
        'group_id' => $member['group_id'] !== null ? (int) $member['group_id'] : null,
        'role' => $member['role'],
    ],
], 201);
