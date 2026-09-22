<?php
// 回覧板を開いた際に既読登録する。POST /v1/circular_read.php?id={circular_id}
require_once __DIR__ . '/../lib/bootstrap.php';
require_once __DIR__ . '/../lib/auth.php';

$member = current_member();
require_method('POST');

$circularId = (int) ($_GET['id'] ?? 0);
if ($circularId <= 0) {
    json_error('VALIDATION_ERROR', 'idが不正です', 422);
}

$pdo = Database::connection();
$stmt = $pdo->prepare(
    'INSERT IGNORE INTO circular_reads (circular_id, member_id) VALUES (:circular_id, :member_id)'
);
$stmt->execute(['circular_id' => $circularId, 'member_id' => $member['id']]);

json_ok(['read' => true]);
