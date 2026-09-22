<?php
require_once __DIR__ . '/../../lib/bootstrap.php';

require_method('POST');

$body = json_body();
$required = ['name', 'address', 'phone', 'email', 'family_count', 'group_id', 'password'];
foreach ($required as $field) {
    if (!isset($body[$field]) || $body[$field] === '') {
        json_error('VALIDATION_ERROR', "{$field}を入力してください", 422);
    }
}
if (strlen((string) $body['password']) < 8) {
    json_error('VALIDATION_ERROR', 'パスワードは8文字以上で入力してください', 422);
}

$pdo = Database::connection();

$check = $pdo->prepare('SELECT id FROM members WHERE email = :email');
$check->execute(['email' => $body['email']]);
if ($check->fetch()) {
    json_error('EMAIL_TAKEN', 'このメールアドレスは既に登録されています', 409);
}

$stmt = $pdo->prepare(
    'INSERT INTO members (name, address, phone, email, password_hash, family_count, group_id, role)
     VALUES (:name, :address, :phone, :email, :password_hash, :family_count, :group_id, "none")'
);
$stmt->execute([
    'name' => $body['name'],
    'address' => $body['address'],
    'phone' => $body['phone'],
    'email' => $body['email'],
    'password_hash' => password_hash((string) $body['password'], PASSWORD_DEFAULT),
    'family_count' => (int) $body['family_count'],
    'group_id' => (int) $body['group_id'],
]);

json_ok(['id' => (int) $pdo->lastInsertId()], 201);
