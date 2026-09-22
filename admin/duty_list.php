<?php
require_once __DIR__ . '/includes/Database.php';
require_once __DIR__ . '/includes/auth.php';
$pdo = Database::connection();

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['_action'] ?? '') === 'delete') {
    $stmt = $pdo->prepare('DELETE FROM garbage_duties WHERE id = :id');
    $stmt->execute(['id' => (int) $_POST['id']]);
    header('Location: duty_list.php');
    exit;
}

$pageTitle = 'ゴミ当番管理';
require __DIR__ . '/includes/header.php';

$duties = $pdo->query(
    "SELECT d.id, DATE_FORMAT(d.month, '%Y年%m月') AS month_label, m.name, g.name AS group_name
     FROM garbage_duties d
     LEFT JOIN members m ON m.id = d.member_id
     LEFT JOIN member_groups g ON g.id = m.group_id
     ORDER BY d.month"
)->fetchAll();
?>

<div class="d-flex justify-content-end mb-3">
  <a href="duty_form.php" class="btn btn-primary">+ 新規登録</a>
</div>

<table class="table table-hover bg-white align-middle">
  <thead>
    <tr><th>月</th><th>担当者</th><th>グループ</th><th class="text-end">操作</th></tr>
  </thead>
  <tbody>
    <?php foreach ($duties as $d): ?>
    <tr>
      <td><?php echo htmlspecialchars($d['month_label']); ?></td>
      <td><?php echo htmlspecialchars($d['name'] ?? '未設定'); ?></td>
      <td><span class="text-muted"><?php echo htmlspecialchars($d['group_name'] ?? '—'); ?></span></td>
      <td class="text-end">
        <a href="duty_form.php?id=<?php echo $d['id']; ?>" class="btn btn-sm btn-outline-secondary">編集</a>
        <form action="duty_list.php" method="post" class="d-inline" onsubmit="return confirm('削除しますか？');">
          <input type="hidden" name="_action" value="delete">
          <input type="hidden" name="id" value="<?php echo $d['id']; ?>">
          <button class="btn btn-sm btn-outline-danger" type="submit">削除</button>
        </form>
      </td>
    </tr>
    <?php endforeach; ?>
    <?php if (!$duties): ?>
    <tr><td colspan="4" class="text-center text-muted py-4">ゴミ当番が登録されていません</td></tr>
    <?php endif; ?>
  </tbody>
</table>

<?php require __DIR__ . '/includes/footer.php'; ?>
