<?php
require_once __DIR__ . '/includes/Database.php';
require_once __DIR__ . '/includes/auth.php';
$pdo = Database::connection();

$error = null;
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $title = trim($_POST['title'] ?? '');
    $body = trim($_POST['body'] ?? '');
    $startDate = $_POST['start_date'] ?? '';
    $endDate = $_POST['end_date'] ?? '';

    if ($title !== '' && $startDate !== '' && $endDate !== '') {
        // 画像アップロードの保存処理は未実装（api/README.md参照）。現時点ではimage_pathはNULLのまま登録する。
        $stmt = $pdo->prepare('INSERT INTO circulars (title, body, start_date, end_date) VALUES (:title, :body, :start_date, :end_date)');
        $stmt->execute(['title' => $title, 'body' => $body ?: null, 'start_date' => $startDate, 'end_date' => $endDate]);
        header('Location: circular_list.php');
        exit;
    }
    $error = 'タイトル・掲載開始日・掲載終了日は必須です';
}

$pageTitle = '回覧板 新規登録';
require __DIR__ . '/includes/header.php';
?>

<form action="circular_form.php" method="post" enctype="multipart/form-data" class="bg-white p-4 rounded shadow-sm" style="max-width:640px;">
  <?php if ($error): ?>
    <div class="alert alert-danger py-2 small"><?php echo htmlspecialchars($error); ?></div>
  <?php endif; ?>
  <div class="mb-3">
    <label class="form-label">タイトル</label>
    <input type="text" class="form-control" name="title" value="<?php echo htmlspecialchars($_POST['title'] ?? ''); ?>">
  </div>
  <div class="mb-3">
    <label class="form-label">本文</label>
    <textarea class="form-control" name="body" rows="4"><?php echo htmlspecialchars($_POST['body'] ?? ''); ?></textarea>
  </div>
  <div class="mb-3">
    <label class="form-label">画像</label>
    <input type="file" class="form-control" name="image">
    <div class="form-text">画像の保存処理は未実装です（登録自体は画像なしで行えます）。</div>
  </div>
  <div class="row mb-3">
    <div class="col">
      <label class="form-label">掲載開始日</label>
      <input type="date" class="form-control" name="start_date" value="<?php echo htmlspecialchars($_POST['start_date'] ?? ''); ?>">
    </div>
    <div class="col">
      <label class="form-label">掲載終了日</label>
      <input type="date" class="form-control" name="end_date" value="<?php echo htmlspecialchars($_POST['end_date'] ?? ''); ?>">
    </div>
  </div>
  <button type="submit" class="btn btn-primary">登録</button>
  <a href="circular_list.php" class="btn btn-outline-secondary">キャンセル</a>
</form>

<?php require __DIR__ . '/includes/footer.php'; ?>
