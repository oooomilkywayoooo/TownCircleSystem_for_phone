<?php
require_once __DIR__ . '/includes/Database.php';
require_once __DIR__ . '/includes/auth.php';
$pdo = Database::connection();

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['_action'] ?? '') === 'delete') {
    $stmt = $pdo->prepare('DELETE FROM schedules WHERE id = :id');
    $stmt->execute(['id' => (int) $_POST['id']]);
    header('Location: schedule_list.php');
    exit;
}

$pageTitle = 'スケジュール管理';
require __DIR__ . '/includes/header.php';

$schedules = $pdo->query('SELECT id, date, title FROM schedules ORDER BY date')->fetchAll();
?>

<div class="d-flex justify-content-end mb-3">
  <a href="schedule_form.php" class="btn btn-primary">+ 新規登録</a>
</div>

<table class="table table-hover bg-white align-middle">
  <thead>
    <tr><th>日付</th><th>タイトル</th><th class="text-end">操作</th></tr>
  </thead>
  <tbody>
    <?php foreach ($schedules as $s): ?>
    <tr>
      <td><?php echo htmlspecialchars($s['date']); ?></td>
      <td><?php echo htmlspecialchars($s['title']); ?></td>
      <td class="text-end">
        <a href="schedule_form.php?id=<?php echo $s['id']; ?>" class="btn btn-sm btn-outline-secondary">編集</a>
        <form action="schedule_list.php" method="post" class="d-inline" onsubmit="return confirm('削除しますか？');">
          <input type="hidden" name="_action" value="delete">
          <input type="hidden" name="id" value="<?php echo $s['id']; ?>">
          <button class="btn btn-sm btn-outline-danger" type="submit">削除</button>
        </form>
      </td>
    </tr>
    <?php endforeach; ?>
    <?php if (!$schedules): ?>
    <tr><td colspan="3" class="text-center text-muted py-4">スケジュールがありません</td></tr>
    <?php endif; ?>
  </tbody>
</table>

<?php require __DIR__ . '/includes/footer.php'; ?>
