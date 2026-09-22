<?php
$editMode = isset($_GET['id']);
$pageTitle = $editMode ? 'ゴミ当番編集' : 'ゴミ当番新規登録';
require __DIR__ . '/includes/header.php';

$members = [
    ['name' => '佐藤 太郎', 'group' => '1組'],
    ['name' => '鈴木 花子', 'group' => '2組'],
    ['name' => '高橋 次郎', 'group' => '1組'],
];
$data = $editMode
    ? ['month' => '2026-07', 'name' => '鈴木 花子']
    : ['month' => '', 'name' => $members[0]['name']];
?>

<form action="duty_list.php" method="post" class="bg-white p-4 rounded shadow-sm" style="max-width:480px;">
  <div class="mb-3">
    <label class="form-label">対象月</label>
    <input type="month" class="form-control" name="month" value="<?php echo htmlspecialchars($data['month']); ?>">
  </div>
  <div class="mb-3">
    <label class="form-label">担当者</label>
    <select class="form-select" name="name">
      <?php foreach ($members as $m): ?>
        <option <?php echo $m['name'] === $data['name'] ? 'selected' : ''; ?>>
          <?php echo htmlspecialchars($m['name']); ?>（<?php echo htmlspecialchars($m['group']); ?>）
        </option>
      <?php endforeach; ?>
    </select>
    <div class="form-text">会員一覧から担当者を選択します。組単位ではなく個人単位での割り当てです。</div>
  </div>
  <button type="submit" class="btn btn-primary"><?php echo $editMode ? '更新' : '登録'; ?></button>
  <a href="duty_list.php" class="btn btn-outline-secondary">キャンセル</a>
</form>

<?php require __DIR__ . '/includes/footer.php'; ?>
