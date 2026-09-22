<?php
require_once __DIR__ . '/includes/Database.php';
require_once __DIR__ . '/includes/auth.php';
$pdo = Database::connection();

$error = null;
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $title = trim($_POST['title'] ?? '');
    $url = trim($_POST['url'] ?? '');

    if ($title !== '' && $url !== '') {
        $stmt = $pdo->prepare('INSERT INTO surveys (title, google_form_url, published_at) VALUES (:title, :url, CURDATE())');
        $stmt->execute(['title' => $title, 'url' => $url]);
        header('Location: survey_list.php');
        exit;
    }
    $error = 'タイトルとGoogleフォームURLは必須です';
}

$pageTitle = 'アンケート新規登録';
require __DIR__ . '/includes/header.php';
?>

<form action="survey_form.php" method="post" class="bg-white p-4 rounded shadow-sm" style="max-width:560px;">
  <?php if ($error): ?>
    <div class="alert alert-danger py-2 small"><?php echo htmlspecialchars($error); ?></div>
  <?php endif; ?>
  <div class="mb-3">
    <label class="form-label">タイトル</label>
    <input type="text" class="form-control" name="title" value="<?php echo htmlspecialchars($_POST['title'] ?? ''); ?>">
  </div>
  <div class="mb-3">
    <label class="form-label">GoogleフォームURL</label>
    <input type="url" class="form-control" name="url" placeholder="https://forms.gle/..." value="<?php echo htmlspecialchars($_POST['url'] ?? ''); ?>">
  </div>
  <button type="submit" class="btn btn-primary">登録</button>
  <a href="survey_list.php" class="btn btn-outline-secondary">キャンセル</a>
</form>

<?php require __DIR__ . '/includes/footer.php'; ?>
