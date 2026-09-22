<?php
$pageTitle = 'アンケート新規登録';
require __DIR__ . '/includes/header.php';
?>

<form action="survey_list.php" method="post" class="bg-white p-4 rounded shadow-sm" style="max-width:560px;">
  <div class="mb-3">
    <label class="form-label">タイトル</label>
    <input type="text" class="form-control" name="title">
  </div>
  <div class="mb-3">
    <label class="form-label">GoogleフォームURL</label>
    <input type="url" class="form-control" name="url" placeholder="https://forms.gle/...">
  </div>
  <button type="submit" class="btn btn-primary">登録</button>
  <a href="survey_list.php" class="btn btn-outline-secondary">キャンセル</a>
</form>

<?php require __DIR__ . '/includes/footer.php'; ?>
