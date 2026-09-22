<?php
// 組長用の受信箱：自分の組のメンバー一覧を、各メンバーとの最新メッセージ付きで返す。
// needs_reply は「そのスレッドの最新メッセージが組長(自分)以外からのものか」で判定する
// （既読テーブルを別途持たずに「対応待ち」を近似する）。
require_once __DIR__ . '/../lib/bootstrap.php';
require_once __DIR__ . '/../lib/auth.php';

$member = current_member();
require_method('GET');

if ($member['role'] !== 'leader') {
    json_error('FORBIDDEN', '組長のみ利用できます', 403);
}

$pdo = Database::connection();
$stmt = $pdo->prepare(
    'SELECT gm.id AS member_id, gm.name, gm.role,
            lm.body AS last_message_body,
            lm.created_at AS last_message_at,
            lm.sender_member_id AS last_message_sender_id
     FROM members gm
     LEFT JOIN (
         SELECT cm.*,
                ROW_NUMBER() OVER (PARTITION BY cm.member_id ORDER BY cm.created_at DESC) AS rn
         FROM chat_messages cm
         WHERE cm.room_type = "leader_dm"
     ) lm ON lm.member_id = gm.id AND lm.rn = 1
     WHERE gm.group_id = :group_id AND gm.id != :self_id
     ORDER BY gm.name'
);
$stmt->execute(['group_id' => $member['group_id'], 'self_id' => $member['id']]);
$rows = $stmt->fetchAll();

$result = array_map(function ($row) use ($member) {
    $hasMessage = $row['last_message_body'] !== null;
    return [
        'member_id' => (int) $row['member_id'],
        'name' => $row['name'],
        'role' => $row['role'],
        'last_message' => $hasMessage ? $row['last_message_body'] : null,
        'last_message_at' => $hasMessage ? $row['last_message_at'] : null,
        'needs_reply' => $hasMessage && (int) $row['last_message_sender_id'] !== (int) $member['id'],
    ];
}, $rows);

json_ok($result);
