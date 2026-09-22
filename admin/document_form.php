<?php
$pageTitle = '資料新規登録';
require __DIR__ . '/includes/header.php';
?>

<form action="document_list.php" method="post" enctype="multipart/form-data" class="bg-white p-4 rounded shadow-sm" style="max-width:480px;">
  <div class="mb-3">
    <label class="form-label">資料名</label>
    <input type="text" class="form-control" name="name">
  </div>
  <div class="mb-3">
    <label class="form-label">ファイル</label>
    <input type="file" class="form-control" name="file">
  </div>
  <button type="submit" class="btn btn-primary">登録</button>
  <a href="document_list.php" class="btn btn-outline-secondary">キャンセル</a>
</form>

<?php require __DIR__ . '/includes/footer.php'; ?>
