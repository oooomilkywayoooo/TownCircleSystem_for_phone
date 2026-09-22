<?php
require_once __DIR__ . '/includes/Database.php';
require_once __DIR__ . '/includes/auth.php';
$pdo = Database::connection();

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['_action'] ?? '') === 'delete') {
    $stmt = $pdo->prepare('DELETE FROM documents WHERE id = :id');
    $stmt->execute(['id' => (int) $_POST['id']]);
    header('Location: document_list.php');
    exit;
}

$pageTitle = '資料管理';
require __DIR__ . '/includes/header.php';

$documents = $pdo->query('SELECT id, name, file_path, uploaded_at FROM documents ORDER BY uploaded_at DESC')->fetchAll();
?>

<div class="d-flex justify-content-end mb-3">
  <a href="document_form.php" class="btn btn-primary">+ 新規登録</a>
</div>

<table class="table table-hover bg-white align-middle">
  <thead>
    <tr><th>資料名</th><th>アップロード日</th><th class="text-end">操作</th></tr>
  </thead>
  <tbody>
    <?php foreach ($documents as $d): ?>
    <tr>
      <td><?php echo htmlspecialchars($d['name']); ?></td>
      <td><?php echo htmlspecialchars($d['uploaded_at']); ?></td>
      <td class="text-end">
        <a href="<?php echo htmlspecialchars($d['file_path'] ?: '#'); ?>" class="btn btn-sm btn-outline-secondary">ダウンロード</a>
        <form action="document_list.php" method="post" class="d-inline" onsubmit="return confirm('削除しますか？');">
          <input type="hidden" name="_action" value="delete">
          <input type="hidden" name="id" value="<?php echo $d['id']; ?>">
          <button class="btn btn-sm btn-outline-danger" type="submit">削除</button>
        </form>
      </td>
    </tr>
    <?php endforeach; ?>
    <?php if (!$documents): ?>
    <tr><td colspan="3" class="text-center text-muted py-4">資料がありません</td></tr>
    <?php endif; ?>
  </tbody>
</table>

<?php require __DIR__ . '/includes/footer.php'; ?>
