<?php
require_once __DIR__ . '/../lib/bootstrap.php';
require_once __DIR__ . '/../lib/auth.php';

current_member();
require_method('GET');

$pdo = Database::connection();
$stmt = $pdo->query(
    'SELECT d.id, DATE_FORMAT(d.month, "%Y-%m") AS month, m.id AS member_id, m.name AS member_name
     FROM garbage_duties d
     LEFT JOIN members m ON m.id = d.member_id
     ORDER BY d.month ASC'
);
json_ok($stmt->fetchAll());
