<?php
require_once __DIR__ . '/../lib/bootstrap.php';
require_once __DIR__ . '/../lib/auth.php';

current_member();
require_method('GET');

$pdo = Database::connection();
$stmt = $pdo->query('SELECT id, title, body, published_at FROM notices ORDER BY published_at DESC');
json_ok($stmt->fetchAll());
