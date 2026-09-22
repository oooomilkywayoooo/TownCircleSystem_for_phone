<?php
require_once __DIR__ . '/../lib/bootstrap.php';

require_method('GET');

$pdo = Database::connection();
$stmt = $pdo->query(
    'SELECT id, name FROM member_groups WHERE is_active = 1 ORDER BY sort_order'
);
json_ok($stmt->fetchAll());
