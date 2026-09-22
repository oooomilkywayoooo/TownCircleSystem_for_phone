<?php
require_once __DIR__ . '/includes/Database.php';
require_once __DIR__ . '/includes/auth.php';
$pdo = Database::connection();

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['_action'] ?? '') === 'delete') {
    $stmt = $pdo->prepare('DELETE FROM circulars WHERE id = :id');
    $stmt->execute(['id' => (int) $_POST['id']]);
    header('Location: circular_list.php');
    exit;
}

$pageTitle = '回覧板管理';
require __DIR__ . '/includes/header.php';

$totalMembers = (int) $pdo->query('SELECT COUNT(*) FROM members')->fetchColumn();
$circulars = $pdo->query(
    'SELECT c.id, c.title, c.start_date, c.end_date, COUNT(cr.id) AS read_count
     FROM circulars c
     LEFT JOIN circular_reads cr ON cr.circular_id = c.id
     GROUP BY c.id
     ORDER BY c.start_date DESC'
)->fetchAll();
?>

<div class="d-flex justify-content-end mb-3">
  <a href="circular_form.php" class="btn btn-primary">+ 新規登録</a>
</div>

<table class="table table-hover bg-white align-middle">
  <thead>
    <tr><th>タイトル</th><th>掲載期間</th><th>既読状況</th><th class="text-end">操作</th></tr>
  </thead>
  <tbody>
    <?php foreach ($circulars as $c): ?>
    <tr>
      <td><?php echo htmlspecialchars($c['title']); ?></td>
      <td><?php echo htmlspecialchars($c['start_date']); ?> 〜 <?php echo htmlspecialchars($c['end_date']); ?></td>
      <td>
        <a href="circular_read_status.php?id=<?php echo $c['id']; ?>"><?php echo $c['read_count']; ?> / <?php echo $totalMembers; ?> 人既読</a>
      </td>
      <td class="text-end">
        <form action="circular_list.php" method="post" class="d-inline" onsubmit="return confirm('削除しますか？');">
          <input type="hidden" name="_action" value="delete">
          <input type="hidden" name="id" value="<?php echo $c['id']; ?>">
          <button class="btn btn-sm btn-outline-danger" type="submit">削除</button>
        </form>
      </td>
    </tr>
    <?php endforeach; ?>
    <?php if (!$circulars): ?>
    <tr><td colspan="4" class="text-center text-muted py-4">回覧板がありません</td></tr>
    <?php endif; ?>
  </tbody>
</table>

<?php require __DIR__ . '/includes/footer.php'; ?>
