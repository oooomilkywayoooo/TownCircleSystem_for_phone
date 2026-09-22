<?php
require_once __DIR__ . '/includes/Database.php';
require_once __DIR__ . '/includes/auth.php';
$pdo = Database::connection();

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['_action'] ?? '') === 'delete') {
    $stmt = $pdo->prepare('DELETE FROM surveys WHERE id = :id');
    $stmt->execute(['id' => (int) $_POST['id']]);
    header('Location: survey_list.php');
    exit;
}

$pageTitle = 'アンケート管理';
require __DIR__ . '/includes/header.php';

$surveys = $pdo->query('SELECT id, title, google_form_url, published_at FROM surveys ORDER BY published_at DESC')->fetchAll();
?>

<div class="d-flex justify-content-end mb-3">
  <a href="survey_form.php" class="btn btn-primary">+ 新規登録</a>
</div>

<table class="table table-hover bg-white align-middle">
  <thead>
    <tr><th>タイトル</th><th>Googleフォーム</th><th>作成日</th><th class="text-end">操作</th></tr>
  </thead>
  <tbody>
    <?php foreach ($surveys as $s): ?>
    <tr>
      <td><?php echo htmlspecialchars($s['title']); ?></td>
      <td><a href="<?php echo htmlspecialchars($s['google_form_url']); ?>" target="_blank" rel="noopener">フォームを開く</a></td>
      <td><?php echo htmlspecialchars($s['published_at']); ?></td>
      <td class="text-end">
        <form action="survey_list.php" method="post" class="d-inline" onsubmit="return confirm('削除しますか？');">
          <input type="hidden" name="_action" value="delete">
          <input type="hidden" name="id" value="<?php echo $s['id']; ?>">
          <button class="btn btn-sm btn-outline-danger" type="submit">削除</button>
        </form>
      </td>
    </tr>
    <?php endforeach; ?>
    <?php if (!$surveys): ?>
    <tr><td colspan="4" class="text-center text-muted py-4">アンケートがありません</td></tr>
    <?php endif; ?>
  </tbody>
</table>

<?php require __DIR__ . '/includes/footer.php'; ?>
