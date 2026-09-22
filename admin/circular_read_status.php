<?php
require_once __DIR__ . '/includes/Database.php';
require_once __DIR__ . '/includes/auth.php';
$pdo = Database::connection();

$id = (int) ($_GET['id'] ?? 0);
$stmt = $pdo->prepare('SELECT title FROM circulars WHERE id = :id');
$stmt->execute(['id' => $id]);
$circular = $stmt->fetch();

if (!$circular) {
    header('Location: circular_list.php');
    exit;
}

$pageTitle = '回覧板 既読確認';
require __DIR__ . '/includes/header.php';

$stmt = $pdo->prepare(
    'SELECT m.name, g.name AS group_name, (cr.id IS NOT NULL) AS is_read
     FROM members m
     LEFT JOIN member_groups g ON g.id = m.group_id
     LEFT JOIN circular_reads cr ON cr.circular_id = :id AND cr.member_id = m.id
     ORDER BY g.sort_order, m.name'
);
$stmt->execute(['id' => $id]);
$members = $stmt->fetchAll();
?>

<p class="mb-3">対象回覧板：<strong><?php echo htmlspecialchars($circular['title']); ?></strong></p>

<table class="table table-hover bg-white align-middle">
  <thead>
    <tr><th>氏名</th><th>グループ</th><th>既読状況</th></tr>
  </thead>
  <tbody>
    <?php foreach ($members as $m): ?>
    <tr>
      <td><?php echo htmlspecialchars($m['name']); ?></td>
      <td><?php echo htmlspecialchars($m['group_name'] ?? '未所属'); ?></td>
      <td>
        <?php if ($m['is_read']): ?>
          <span class="badge bg-success">既読</span>
        <?php else: ?>
          <span class="badge bg-secondary">未読</span>
        <?php endif; ?>
      </td>
    </tr>
    <?php endforeach; ?>
    <?php if (!$members): ?>
    <tr><td colspan="3" class="text-center text-muted py-4">会員がいません</td></tr>
    <?php endif; ?>
  </tbody>
</table>

<a href="circular_list.php" class="btn btn-outline-secondary">一覧へ戻る</a>

<?php require __DIR__ . '/includes/footer.php'; ?>
