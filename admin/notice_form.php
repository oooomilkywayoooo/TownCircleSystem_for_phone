<?php
require_once __DIR__ . '/includes/Database.php';
require_once __DIR__ . '/includes/auth.php';
$pdo = Database::connection();

$editMode = isset($_GET['id']);
$id = $editMode ? (int) $_GET['id'] : null;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $title = trim($_POST['title'] ?? '');
    $body = trim($_POST['body'] ?? '');
    $publishedAt = $_POST['date'] ?? '';
    $postedId = isset($_POST['id']) && $_POST['id'] !== '' ? (int) $_POST['id'] : null;

    if ($title !== '' && $publishedAt !== '') {
        if ($postedId) {
            $stmt = $pdo->prepare('UPDATE notices SET title=:title, body=:body, published_at=:published_at WHERE id=:id');
            $stmt->execute(['title' => $title, 'body' => $body, 'published_at' => $publishedAt, 'id' => $postedId]);
        } else {
            $stmt = $pdo->prepare('INSERT INTO notices (title, body, published_at) VALUES (:title, :body, :published_at)');
            $stmt->execute(['title' => $title, 'body' => $body, 'published_at' => $publishedAt]);
        }
        header('Location: notice_list.php');
        exit;
    }
    $error = 'タイトルと公開日は必須です';
    $data = ['title' => $title, 'body' => $body, 'date' => $publishedAt];
} elseif ($editMode) {
    $stmt = $pdo->prepare('SELECT title, body, published_at FROM notices WHERE id = :id');
    $stmt->execute(['id' => $id]);
    $row = $stmt->fetch();
    if (!$row) {
        header('Location: notice_list.php');
        exit;
    }
    $data = ['title' => $row['title'], 'body' => $row['body'], 'date' => $row['published_at']];
} else {
    $data = ['title' => '', 'body' => '', 'date' => ''];
}

$pageTitle = $editMode ? 'お知らせ編集' : 'お知らせ新規登録';
require __DIR__ . '/includes/header.php';
?>

<form action="notice_form.php<?php echo $editMode ? '?id=' . $id : ''; ?>" method="post" class="bg-white p-4 rounded shadow-sm" style="max-width:640px;">
  <?php if (!empty($error)): ?>
    <div class="alert alert-danger py-2 small"><?php echo htmlspecialchars($error); ?></div>
  <?php endif; ?>
  <?php if ($editMode): ?>
    <input type="hidden" name="id" value="<?php echo $id; ?>">
  <?php endif; ?>
  <div class="mb-3">
    <label class="form-label">タイトル</label>
    <input type="text" class="form-control" name="title" value="<?php echo htmlspecialchars($data['title']); ?>">
  </div>
  <div class="mb-3">
    <label class="form-label">本文</label>
    <textarea class="form-control" name="body" rows="5"><?php echo htmlspecialchars($data['body']); ?></textarea>
  </div>
  <div class="mb-3">
    <label class="form-label">公開日</label>
    <input type="date" class="form-control" name="date" value="<?php echo htmlspecialchars($data['date']); ?>">
  </div>
  <button type="submit" class="btn btn-primary"><?php echo $editMode ? '更新' : '登録'; ?></button>
  <a href="notice_list.php" class="btn btn-outline-secondary">キャンセル</a>
</form>

<?php require __DIR__ . '/includes/footer.php'; ?>
