<?php
require_once __DIR__ . '/includes/Database.php';
require_once __DIR__ . '/includes/auth.php';
$pdo = Database::connection();

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['_action'] ?? '') === 'delete') {
    $stmt = $pdo->prepare('DELETE FROM notices WHERE id = :id');
    $stmt->execute(['id' => (int) $_POST['id']]);
    header('Location: notice_list.php');
    exit;
}

$pageTitle = 'お知らせ管理';
require __DIR__ . '/includes/header.php';

$notices = $pdo->query('SELECT id, title, published_at FROM notices ORDER BY published_at DESC')->fetchAll();
?>

<div class="d-flex justify-content-end mb-3">
  <a href="notice_form.php" class="btn btn-primary">+ 新規登録</a>
</div>

<table class="table table-hover bg-white align-middle">
  <thead>
    <tr><th>タイトル</th><th>投稿日</th><th class="text-end">操作</th></tr>
  </thead>
  <tbody>
    <?php foreach ($notices as $n): ?>
    <tr>
      <td><?php echo htmlspecialchars($n['title']); ?></td>
      <td><?php echo htmlspecialchars($n['published_at']); ?></td>
      <td class="text-end">
        <a href="notice_form.php?id=<?php echo $n['id']; ?>" class="btn btn-sm btn-outline-secondary">編集</a>
        <form action="notice_list.php" method="post" class="d-inline" onsubmit="return confirm('削除しますか？');">
          <input type="hidden" name="_action" value="delete">
          <input type="hidden" name="id" value="<?php echo $n['id']; ?>">
          <button class="btn btn-sm btn-outline-danger" type="submit">削除</button>
        </form>
      </td>
    </tr>
    <?php endforeach; ?>
    <?php if (!$notices): ?>
    <tr><td colspan="3" class="text-center text-muted py-4">お知らせがありません</td></tr>
    <?php endif; ?>
  </tbody>
</table>

<?php require __DIR__ . '/includes/footer.php'; ?>
