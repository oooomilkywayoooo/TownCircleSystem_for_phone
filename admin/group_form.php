<?php
$pageTitle = 'グループ新規登録';
require __DIR__ . '/includes/header.php';
?>

<form action="group_list.php" method="post" class="bg-white p-4 rounded shadow-sm" style="max-width:480px;">
  <div class="mb-3">
    <label class="form-label">グループ名</label>
    <input type="text" class="form-control" name="name">
  </div>
  <div class="mb-3 form-check form-switch">
    <input class="form-check-input" type="checkbox" role="switch" name="active" checked>
    <label class="form-check-label">有効フラグ</label>
  </div>
  <button type="submit" class="btn btn-primary">登録</button>
  <a href="group_list.php" class="btn btn-outline-secondary">キャンセル</a>
</form>

<?php require __DIR__ . '/includes/footer.php'; ?>
