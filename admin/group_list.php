<?php
require_once __DIR__ . '/includes/Database.php';
require_once __DIR__ . '/includes/auth.php';
$pdo = Database::connection();

$pageTitle = 'グループ管理';
require __DIR__ . '/includes/header.php';

$groups = $pdo->query(
    'SELECT g.id, g.name, g.is_active, COUNT(m.id) AS member_count
     FROM member_groups g
     LEFT JOIN members m ON m.group_id = g.id
     GROUP BY g.id
     ORDER BY g.sort_order'
)->fetchAll();
?>

<div class="d-flex justify-content-end mb-3">
  <a href="group_form.php" class="btn btn-primary">+ 新規登録</a>
</div>

<table class="table table-hover bg-white align-middle">
  <thead>
    <tr><th>グループ名</th><th>所属人数</th><th>状態</th><th class="text-end">操作</th></tr>
  </thead>
  <tbody>
    <?php foreach ($groups as $g): ?>
    <tr>
      <td><a href="group_detail.php?id=<?php echo $g['id']; ?>"><?php echo htmlspecialchars($g['name']); ?></a></td>
      <td><?php echo (int) $g['member_count']; ?>人</td>
      <td>
        <?php if ($g['is_active']): ?>
          <span class="badge bg-success">有効</span>
        <?php else: ?>
          <span class="badge bg-secondary">無効</span>
        <?php endif; ?>
      </td>
      <td class="text-end">
        <a href="group_detail.php?id=<?php echo $g['id']; ?>" class="btn btn-sm btn-outline-secondary">詳細</a>
      </td>
    </tr>
    <?php endforeach; ?>
    <?php if (!$groups): ?>
    <tr><td colspan="4" class="text-center text-muted py-4">グループがありません</td></tr>
    <?php endif; ?>
  </tbody>
</table>

<?php require __DIR__ . '/includes/footer.php'; ?>
