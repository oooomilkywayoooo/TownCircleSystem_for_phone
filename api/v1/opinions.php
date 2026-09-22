<?php
// ご意見箱への投稿。is_anonymous=trueの場合、DBにもmember_idを保存せず本当に匿名にする。
require_once __DIR__ . '/../lib/bootstrap.php';
require_once __DIR__ . '/../lib/auth.php';

$member = current_member();
require_method('POST');

$body = json_body();
$text = trim((string) ($body['body'] ?? ''));
if ($text === '') {
    json_error('VALIDATION_ERROR', 'ご意見の内容を入力してください', 422);
}
$isAnonymous = !empty($body['is_anonymous']);

$pdo = Database::connection();
$stmt = $pdo->prepare(
    'INSERT INTO opinions (body, is_anonymous, member_id) VALUES (:body, :is_anonymous, :member_id)'
);
$stmt->execute([
    'body' => $text,
    'is_anonymous' => $isAnonymous ? 1 : 0,
    'member_id' => $isAnonymous ? null : $member['id'],
]);

json_ok(['id' => (int) $pdo->lastInsertId()], 201);
