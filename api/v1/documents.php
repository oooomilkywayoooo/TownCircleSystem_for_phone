<?php
require_once __DIR__ . '/../lib/bootstrap.php';
require_once __DIR__ . '/../lib/auth.php';

current_member();
require_method('GET');

$pdo = Database::connection();
$stmt = $pdo->query(
    'SELECT id, name, file_path, file_size_bytes, uploaded_at FROM documents ORDER BY uploaded_at DESC'
);
json_ok($stmt->fetchAll());
