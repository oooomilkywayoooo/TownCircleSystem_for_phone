<?php
require_once __DIR__ . '/includes/Database.php';
require_once __DIR__ . '/includes/auth.php';
$pdo = Database::connection();

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['_action'] ?? '') === 'delete') {
    $stmt = $pdo->prepare('DELETE FROM members WHERE id = :id');
    $stmt->execute(['id' => (int) $_POST['id']]);
    header('Location: member_list.php');
    exit;
}

$pageTitle = '会員管理';
require __DIR__ . '/includes/header.php';

$roleLabels = ['none' => '役職なし', 'leader' => '組長', 'vice_leader' => '副組長'];

$members = $pdo->query(
    'SELECT m.id, m.name, m.phone, m.role, g.name AS group_name
     FROM members m
     LEFT JOIN member_groups g ON g.id = m.group_id
     ORDER BY g.sort_order, m.name'
)->fetchAll();
?>

<table class="table table-hover bg-white align-middle">
  <thead>
    <tr><th>氏名</th><th>グループ</th><th>役職</th><th>電話番号</th><th class="text-end">操作</th></tr>
  </thead>
  <tbody>
    <?php foreach ($members as $m): ?>
    <tr>
      <td><a href="member_detail.php?id=<?php echo $m['id']; ?>"><?php echo htmlspecialchars($m['name']); ?></a></td>
      <td><?php echo htmlspecialchars($m['group_name'] ?? '未所属'); ?></td>
      <td>
        <?php if ($m['role'] !== 'none'): ?>
          <span class="badge bg-primary"><?php echo htmlspecialchars($roleLabels[$m['role']] ?? $m['role']); ?></span>
        <?php else: ?>
          <span class="text-muted">—</span>
        <?php endif; ?>
      </td>
      <td><?php echo htmlspecialchars($m['phone']); ?></td>
      <td class="text-end">
        <a href="member_detail.php?id=<?php echo $m['id']; ?>" class="btn btn-sm btn-outline-secondary">詳細</a>
        <form action="member_list.php" method="post" class="d-inline" onsubmit="return confirm('削除しますか？');">
          <input type="hidden" name="_action" value="delete">
          <input type="hidden" name="id" value="<?php echo $m['id']; ?>">
          <button class="btn btn-sm btn-outline-danger" type="submit">削除</button>
        </form>
      </td>
    </tr>
    <?php endforeach; ?>
    <?php if (!$members): ?>
    <tr><td colspan="5" class="text-center text-muted py-4">会員がいません</td></tr>
    <?php endif; ?>
  </tbody>
</table>

<?php require __DIR__ . '/includes/footer.php'; ?>
