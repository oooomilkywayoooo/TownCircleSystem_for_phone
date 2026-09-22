<?php
// 自分（ログイン中の会員）と、自分の組の組長との個別チャット。GET=取得、POST=投稿。
// 注意: スレッドは常に「ログイン中の会員自身」を軸に特定する（member_id = 自分のid）。
// 組長がこのエンドポイントでログインした場合も自分自身のスレッド（＝自組の組長とのやり取り）が返るだけで、
// 他の会員のスレッド一覧を見たり代理返信したりする機能（組長用の受信箱）はまだ実装していない。
require_once __DIR__ . '/../lib/bootstrap.php';
require_once __DIR__ . '/../lib/auth.php';

$member = current_member();
$pdo = Database::connection();

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $stmt = $pdo->prepare(
        'SELECT cm.id, cm.sender_is_admin, cm.body, cm.created_at,
                m.id AS sender_member_id, m.name AS sender_name
         FROM chat_messages cm
         LEFT JOIN members m ON m.id = cm.sender_member_id
         WHERE cm.room_type = "leader_dm" AND cm.member_id = :member_id
         ORDER BY cm.created_at ASC'
    );
    $stmt->execute(['member_id' => $member['id']]);
    json_ok($stmt->fetchAll());
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $body = json_body();
    $text = trim((string) ($body['body'] ?? ''));
    if ($text === '') {
        json_error('VALIDATION_ERROR', 'メッセージを入力してください', 422);
    }

    $stmt = $pdo->prepare(
        'INSERT INTO chat_messages (room_type, member_id, sender_member_id, sender_is_admin, body)
         VALUES ("leader_dm", :member_id, :sender_member_id, 0, :body)'
    );
    $stmt->execute(['member_id' => $member['id'], 'sender_member_id' => $member['id'], 'body' => $text]);
    json_ok(['id' => (int) $pdo->lastInsertId()], 201);
} else {
    json_error('METHOD_NOT_ALLOWED', 'GETまたはPOSTのみ対応しています', 405);
}
