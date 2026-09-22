<?php
require_once __DIR__ . '/../lib/bootstrap.php';
require_once __DIR__ . '/../lib/auth.php';

current_member();
require_method('GET');

$pdo = Database::connection();
$stmt = $pdo->query('SELECT id, title, google_form_url, published_at FROM surveys ORDER BY published_at DESC');
json_ok($stmt->fetchAll());
