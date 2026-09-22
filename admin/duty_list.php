<?php
$pageTitle = 'ゴミ当番管理';
require __DIR__ . '/includes/header.php';

$duties = [
    ['id' => 1, 'month' => '2026年07月', 'name' => '鈴木 花子', 'group' => '2組'],
    ['id' => 2, 'month' => '2026年08月', 'name' => '高橋 次郎', 'group' => '1組'],
    ['id' => 3, 'month' => '2026年09月', 'name' => '佐藤 太郎', 'group' => '1組'],
];
?>

<div class="d-flex justify-content-end mb-3">
  <a href="duty_form.php" class="btn btn-primary">+ 新規登録</a>
</div>

<table class="table table-hover bg-white align-middle">
  <thead>
    <tr><th>月</th><th>担当者</th><th>グループ</th><th class="text-end">操作</th></tr>
  </thead>
  <tbody>
    <?php foreach ($duties as $d): ?>
    <tr>
      <td><?php echo htmlspecialchars($d['month']); ?></td>
      <td><?php echo htmlspecialchars($d['name']); ?></td>
      <td><span class="text-muted"><?php echo htmlspecialchars($d['group']); ?></span></td>
      <td class="text-end">
        <a href="duty_form.php?id=<?php echo $d['id']; ?>" class="btn btn-sm btn-outline-secondary">編集</a>
        <button class="btn btn-sm btn-outline-danger" type="button">削除</button>
      </td>
    </tr>
    <?php endforeach; ?>
  </tbody>
</table>

<?php require __DIR__ . '/includes/footer.php'; ?>
