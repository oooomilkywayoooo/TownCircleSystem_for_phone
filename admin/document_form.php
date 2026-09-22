<?php
require_once __DIR__ . '/includes/Database.php';
require_once __DIR__ . '/includes/auth.php';
$pdo = Database::connection();

$error = null;
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = trim($_POST['name'] ?? '');

    if ($name !== '') {
        // ファイルアップロードの保存処理は未実装（api/README.md参照）。file_pathはNULLのまま登録する。
        $stmt = $pdo->prepare(
            'INSERT INTO documents (name, file_path, file_size_bytes, uploaded_at) VALUES (:name, NULL, 0, CURDATE())'
        );
        $stmt->execute(['name' => $name]);
        header('Location: document_list.php');
        exit;
    }
    $error = '資料名は必須です';
}

$pageTitle = '資料新規登録';
require __DIR__ . '/includes/header.php';
?>

<form action="document_form.php" method="post" enctype="multipart/form-data" class="bg-white p-4 rounded shadow-sm" style="max-width:480px;">
  <?php if ($error): ?>
    <div class="alert alert-danger py-2 small"><?php echo htmlspecialchars($error); ?></div>
  <?php endif; ?>
  <div class="mb-3">
    <label class="form-label">資料名</label>
    <input type="text" class="form-control" name="name" value="<?php echo htmlspecialchars($_POST['name'] ?? ''); ?>">
  </div>
  <div class="mb-3">
    <label class="form-label">ファイル</label>
    <input type="file" class="form-control" name="file">
    <div class="form-text">ファイルの保存処理は未実装です（登録自体はファイルなしで行えます）。</div>
  </div>
  <button type="submit" class="btn btn-primary">登録</button>
  <a href="document_list.php" class="btn btn-outline-secondary">キャンセル</a>
</form>

<?php require __DIR__ . '/includes/footer.php'; ?>
