<?php
// 町内会全体チャット。GET=取得、POST=投稿。
require_once __DIR__ . '/../lib/bootstrap.php';
require_once __DIR__ . '/../lib/auth.php';

$member = current_member();
$pdo = Database::connection();

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $stmt = $pdo->query(
        'SELECT cm.id, cm.sender_is_admin, cm.body, cm.created_at,
                m.id AS sender_member_id, m.name AS sender_name
         FROM chat_messages cm
         LEFT JOIN members m ON m.id = cm.sender_member_id
         WHERE cm.room_type = "all"
         ORDER BY cm.created_at ASC'
    );
    json_ok($stmt->fetchAll());
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $body = json_body();
    $text = trim((string) ($body['body'] ?? ''));
    if ($text === '') {
        json_error('VALIDATION_ERROR', 'メッセージを入力してください', 422);
    }

    $stmt = $pdo->prepare(
        'INSERT INTO chat_messages (room_type, member_id, sender_member_id, sender_is_admin, body)
         VALUES ("all", NULL, :sender_member_id, 0, :body)'
    );
    $stmt->execute(['sender_member_id' => $member['id'], 'body' => $text]);
    json_ok(['id' => (int) $pdo->lastInsertId()], 201);
} else {
    json_error('METHOD_NOT_ALLOWED', 'GETまたはPOSTのみ対応しています', 405);
}
