<?php
$pageTitle = 'グループ管理';
require __DIR__ . '/includes/header.php';

$groups = [
    ['id' => 1, 'name' => '1丁目班', 'members' => 12, 'active' => true],
    ['id' => 2, 'name' => '2丁目班', 'members' => 9, 'active' => true],
    ['id' => 3, 'name' => '3丁目班', 'members' => 15, 'active' => false],
];
?>

<div class="d-flex justify-content-end mb-3">
  <a href="group_form.php" class="btn btn-primary">+ 新規登録</a>
</div>

<table class="table table-hover bg-white align-middle">
  <thead>
    <tr><th>グループ名</th><th>所属人数</th><th>状態</th><th class="text-end">操作</th></tr>
  </thead>
  <tbody>
    <?php foreach ($groups as $g): ?>
    <tr>
      <td><a href="group_detail.php?id=<?php echo $g['id']; ?>"><?php echo htmlspecialchars($g['name']); ?></a></td>
      <td><?php echo $g['members']; ?>人</td>
      <td>
        <?php if ($g['active']): ?>
          <span class="badge bg-success">有効</span>
        <?php else: ?>
          <span class="badge bg-secondary">無効</span>
        <?php endif; ?>
      </td>
      <td class="text-end">
        <a href="group_detail.php?id=<?php echo $g['id']; ?>" class="btn btn-sm btn-outline-secondary">詳細</a>
      </td>
    </tr>
    <?php endforeach; ?>
  </tbody>
</table>

<?php require __DIR__ . '/includes/footer.php'; ?>
