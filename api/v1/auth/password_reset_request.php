<?php
require_once __DIR__ . '/../../lib/bootstrap.php';

require_method('POST');

$body = json_body();
$email = trim((string) ($body['email'] ?? ''));
if ($email === '') {
    json_error('VALIDATION_ERROR', 'メールアドレスを入力してください', 422);
}

$pdo = Database::connection();
$stmt = $pdo->prepare('SELECT id FROM members WHERE email = :email');
$stmt->execute(['email' => $email]);
$member = $stmt->fetch();

if ($member) {
    $rawToken = bin2hex(random_bytes(32));
    $hashedToken = hash('sha256', $rawToken);
    $insert = $pdo->prepare(
        'INSERT INTO member_password_resets (member_id, token, expires_at)
         VALUES (:member_id, :token, DATE_ADD(NOW(), INTERVAL 30 MINUTE))'
    );
    $insert->execute(['member_id' => $member['id'], 'token' => $hashedToken]);
    // メール送信そのものは未実装。ここではトークンの発行までを行う想定。
}

// 会員の存在有無に関わらず同じレスポンスを返し、登録メールアドレスの推測を防ぐ
json_ok(['message' => 'パスワード再設定用のメールを送信しました（登録されている場合）']);
