<?php
require_once __DIR__ . '/../lib/bootstrap.php';
require_once __DIR__ . '/../lib/auth.php';

$member = current_member();
require_method('GET');

$month = $_GET['month'] ?? null; // YYYY-MM 形式

$pdo = Database::connection();
$sql = 'SELECT c.id, c.title, c.body, c.image_path, c.start_date, c.end_date,
               (cr.id IS NOT NULL) AS is_read
        FROM circulars c
        LEFT JOIN circular_reads cr
               ON cr.circular_id = c.id AND cr.member_id = :member_id';
$params = ['member_id' => $member['id']];

if ($month) {
    $sql .= ' WHERE DATE_FORMAT(c.start_date, "%Y-%m") = :month';
    $params['month'] = $month;
}
$sql .= ' ORDER BY c.start_date DESC';

$stmt = $pdo->prepare($sql);
$stmt->execute($params);
json_ok($stmt->fetchAll());
