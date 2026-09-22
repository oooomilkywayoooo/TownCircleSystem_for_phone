<?php
$editMode = isset($_GET['id']);
$pageTitle = $editMode ? 'スケジュール編集' : 'スケジュール新規登録';
require __DIR__ . '/includes/header.php';

$data = $editMode
    ? ['date' => '2026-07-05', 'title' => '資源ごみ回収', 'detail' => '資源ごみは朝8時までに集積所へ']
    : ['date' => '', 'title' => '', 'detail' => ''];
?>

<form action="schedule_list.php" method="post" class="bg-white p-4 rounded shadow-sm" style="max-width:560px;">
  <div class="mb-3">
    <label class="form-label">日付</label>
    <input type="date" class="form-control" name="date" value="<?php echo htmlspecialchars($data['date']); ?>">
  </div>
  <div class="mb-3">
    <label class="form-label">タイトル</label>
    <input type="text" class="form-control" name="title" value="<?php echo htmlspecialchars($data['title']); ?>">
  </div>
  <div class="mb-3">
    <label class="form-label">詳細</label>
    <textarea class="form-control" name="detail" rows="4"><?php echo htmlspecialchars($data['detail']); ?></textarea>
  </div>
  <button type="submit" class="btn btn-primary"><?php echo $editMode ? '更新' : '登録'; ?></button>
  <a href="schedule_list.php" class="btn btn-outline-secondary">キャンセル</a>
</form>

<?php require __DIR__ . '/includes/footer.php'; ?>
