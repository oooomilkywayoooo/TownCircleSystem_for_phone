<?php
require_once __DIR__ . '/includes/Database.php';
require_once __DIR__ . '/includes/auth.php';
$pdo = Database::connection();

$pageTitle = 'ご意見管理';
require __DIR__ . '/includes/header.php';

// 匿名投稿はmember_idを保存していないため、管理者からも投稿者はわからない（意図した仕様）。
$opinions = $pdo->query(
    "SELECT o.created_at, o.is_anonymous, o.body, m.name
     FROM opinions o
     LEFT JOIN members m ON m.id = o.member_id
     ORDER BY o.created_at DESC"
)->fetchAll();
?>

<table class="table table-hover bg-white align-middle">
  <thead>
    <tr><th>投稿日</th><th>投稿者</th><th>内容</th></tr>
  </thead>
  <tbody>
    <?php foreach ($opinions as $o): ?>
    <tr>
      <td class="text-nowrap"><?php echo htmlspecialchars(substr($o['created_at'], 0, 10)); ?></td>
      <td class="text-nowrap"><?php echo $o['is_anonymous'] ? '匿名' : htmlspecialchars($o['name'] ?? '（退会済み）'); ?></td>
      <td><?php echo htmlspecialchars($o['body']); ?></td>
    </tr>
    <?php endforeach; ?>
    <?php if (!$opinions): ?>
    <tr><td colspan="3" class="text-center text-muted py-4">ご意見はまだありません</td></tr>
    <?php endif; ?>
  </tbody>
</table>

<?php require __DIR__ . '/includes/footer.php'; ?>
