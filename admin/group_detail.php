<?php
$pageTitle = 'グループ詳細';
require __DIR__ . '/includes/header.php';

$group = ['name' => '1丁目班', 'active' => true];
$members = [
    ['name' => '佐藤 太郎', 'phone' => '090-1111-2222'],
    ['name' => '伊藤 光', 'phone' => '090-3333-4444'],
];
?>

<div class="bg-white p-4 rounded shadow-sm mb-4" style="max-width:640px;">
  <dl class="row mb-0">
    <dt class="col-sm-3">グループ名</dt>
    <dd class="col-sm-9"><?php echo htmlspecialchars($group['name']); ?></dd>
    <dt class="col-sm-3">状態</dt>
    <dd class="col-sm-9">
      <div class="form-check form-switch">
        <input class="form-check-input" type="checkbox" role="switch" <?php echo $group['active'] ? 'checked' : ''; ?>>
        <label class="form-check-label">有効フラグ</label>
      </div>
    </dd>
  </dl>
</div>

<h5>所属会員</h5>
<table class="table table-hover bg-white align-middle">
  <thead>
    <tr><th>氏名</th><th>電話番号</th></tr>
  </thead>
  <tbody>
    <?php foreach ($members as $m): ?>
    <tr>
      <td><?php echo htmlspecialchars($m['name']); ?></td>
      <td><?php echo htmlspecialchars($m['phone']); ?></td>
    </tr>
    <?php endforeach; ?>
  </tbody>
</table>

<a href="group_list.php" class="btn btn-outline-secondary">一覧へ戻る</a>

<?php require __DIR__ . '/includes/footer.php'; ?>
