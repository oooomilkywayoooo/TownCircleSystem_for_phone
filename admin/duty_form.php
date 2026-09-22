<?php
$editMode = isset($_GET['id']);
$pageTitle = $editMode ? 'ゴミ当番編集' : 'ゴミ当番新規登録';
require __DIR__ . '/includes/header.php';

$groups = ['1丁目班', '2丁目班', '3丁目班'];
$data = $editMode
    ? ['month' => '2026-07', 'group' => '1丁目班']
    : ['month' => '', 'group' => $groups[0]];
?>

<form action="duty_list.php" method="post" class="bg-white p-4 rounded shadow-sm" style="max-width:480px;">
  <div class="mb-3">
    <label class="form-label">対象月</label>
    <input type="month" class="form-control" name="month" value="<?php echo htmlspecialchars($data['month']); ?>">
  </div>
  <div class="mb-3">
    <label class="form-label">当番グループ</label>
    <select class="form-select" name="group">
      <?php foreach ($groups as $g): ?>
        <option <?php echo $g === $data['group'] ? 'selected' : ''; ?>><?php echo htmlspecialchars($g); ?></option>
      <?php endforeach; ?>
    </select>
  </div>
  <button type="submit" class="btn btn-primary"><?php echo $editMode ? '更新' : '登録'; ?></button>
  <a href="duty_list.php" class="btn btn-outline-secondary">キャンセル</a>
</form>

<?php require __DIR__ . '/includes/footer.php'; ?>
