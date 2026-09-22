<?php
$editMode = isset($_GET['id']);
$pageTitle = $editMode ? 'お知らせ編集' : 'お知らせ新規登録';
require __DIR__ . '/includes/header.php';

$data = $editMode
    ? ['title' => '夏祭りのお知らせ', 'body' => "日時：2026年8月1日\n場所：町内公園", 'date' => '2026-07-01']
    : ['title' => '', 'body' => '', 'date' => ''];
?>

<form action="notice_list.php" method="post" class="bg-white p-4 rounded shadow-sm" style="max-width:640px;">
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
