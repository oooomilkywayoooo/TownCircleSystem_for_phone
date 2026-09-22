<?php
require_once __DIR__ . '/../lib/bootstrap.php';
require_once __DIR__ . '/../lib/auth.php';

current_member();
require_method('GET');

$month = $_GET['month'] ?? null; // YYYY-MM 形式

$pdo = Database::connection();
$sql = 'SELECT id, date, title, detail FROM schedules';
$params = [];
if ($month) {
    $sql .= ' WHERE DATE_FORMAT(date, "%Y-%m") = :month';
    $params['month'] = $month;
}
$sql .= ' ORDER BY date ASC';

$stmt = $pdo->prepare($sql);
$stmt->execute($params);
json_ok($stmt->fetchAll());
