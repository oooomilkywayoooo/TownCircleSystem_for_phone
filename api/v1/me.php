<?php
require_once __DIR__ . '/../lib/bootstrap.php';
require_once __DIR__ . '/../lib/auth.php';

$member = current_member();
$pdo = Database::connection();

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $stmt = $pdo->prepare(
        'SELECT m.id, m.name, m.address, m.phone, m.email, m.family_count, m.role,
                m.group_id, g.name AS group_name
         FROM members m
         LEFT JOIN member_groups g ON g.id = m.group_id
         WHERE m.id = :id'
    );
    $stmt->execute(['id' => $member['id']]);
    json_ok($stmt->fetch());
}

if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    $body = json_body();

    // 会員情報変更画面の仕様：変更前に現在のパスワードを確認する
    $currentPassword = (string) ($body['current_password'] ?? '');
    if (!password_verify($currentPassword, $member['password_hash'])) {
        json_error('INVALID_PASSWORD', '現在のパスワードが正しくありません', 401);
    }

    $passwordHash = $member['password_hash'];
    if (!empty($body['new_password'])) {
        if (strlen((string) $body['new_password']) < 8) {
            json_error('VALIDATION_ERROR', 'パスワードは8文字以上で入力してください', 422);
        }
        $passwordHash = password_hash((string) $body['new_password'], PASSWORD_DEFAULT);
    }

    $stmt = $pdo->prepare(
        'UPDATE members SET name=:name, address=:address, phone=:phone, email=:email,
         family_count=:family_count, group_id=:group_id, password_hash=:password_hash
         WHERE id=:id'
    );
    $stmt->execute([
        'name' => $body['name'] ?? $member['name'],
        'address' => $body['address'] ?? $member['address'],
        'phone' => $body['phone'] ?? $member['phone'],
        'email' => $body['email'] ?? $member['email'],
        'family_count' => (int) ($body['family_count'] ?? $member['family_count']),
        'group_id' => $body['group_id'] ?? $member['group_id'],
        'password_hash' => $passwordHash,
        'id' => $member['id'],
    ]);

    json_ok(['updated' => true]);
}

json_error('METHOD_NOT_ALLOWED', 'GETまたはPUTのみ対応しています', 405);
