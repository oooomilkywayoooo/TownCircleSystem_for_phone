<?php
// 会員本人と、自分の組の組長との個別チャット。GET=取得、POST=投稿。
//
// 通常の会員/副組長: ?member_id を指定せず呼ぶと、常に「自分自身のスレッド」を返す。
// 組長: ?member_id={対象会員のid} を指定すると、その会員とのスレッドを読み書きできる
//       （組長用受信箱からメンバーを選んで開く用途）。対象は自分と同じ組の会員に限る。
require_once __DIR__ . '/../lib/bootstrap.php';
require_once __DIR__ . '/../lib/auth.php';

$member = current_member();
$pdo = Database::connection();

$targetMemberId = $member['id'];
$requestedId = $_GET['member_id'] ?? null;

if ($requestedId !== null && (int) $requestedId !== (int) $member['id']) {
    if ($member['role'] !== 'leader') {
        json_error('FORBIDDEN', '他の会員のスレッドを開く権限がありません', 403);
    }

    $targetStmt = $pdo->prepare('SELECT id, group_id FROM members WHERE id = :id');
    $targetStmt->execute(['id' => (int) $requestedId]);
    $target = $targetStmt->fetch();

    if (!$target || $target['group_id'] === null || $target['group_id'] !== $member['group_id']) {
        json_error('FORBIDDEN', '自分の組以外の会員のスレッドは開けません', 403);
    }

    $targetMemberId = (int) $requestedId;
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $stmt = $pdo->prepare(
        'SELECT cm.id, cm.sender_is_admin, cm.body, cm.created_at,
                m.id AS sender_member_id, m.name AS sender_name
         FROM chat_messages cm
         LEFT JOIN members m ON m.id = cm.sender_member_id
         WHERE cm.room_type = "leader_dm" AND cm.member_id = :member_id
         ORDER BY cm.created_at ASC'
    );
    $stmt->execute(['member_id' => $targetMemberId]);
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
    $stmt->execute(['member_id' => $targetMemberId, 'sender_member_id' => $member['id'], 'body' => $text]);
    json_ok(['id' => (int) $pdo->lastInsertId()], 201);
} else {
    json_error('METHOD_NOT_ALLOWED', 'GETまたはPOSTのみ対応しています', 405);
}
