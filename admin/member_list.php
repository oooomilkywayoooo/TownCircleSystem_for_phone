<?php
$pageTitle = '会員管理';
require __DIR__ . '/includes/header.php';

$members = [
    ['id' => 1, 'name' => '佐藤 太郎', 'group' => '1組', 'role' => '組長', 'phone' => '090-1111-2222'],
    ['id' => 2, 'name' => '鈴木 花子', 'group' => '2組', 'role' => '役職なし', 'phone' => '090-3333-4444'],
    ['id' => 3, 'name' => '高橋 次郎', 'group' => '1組', 'role' => '副組長', 'phone' => '090-5555-6666'],
];
?>

<table class="table table-hover bg-white align-middle">
  <thead>
    <tr><th>氏名</th><th>グループ</th><th>役職</th><th>電話番号</th><th class="text-end">操作</th></tr>
  </thead>
  <tbody>
    <?php foreach ($members as $m): ?>
    <tr>
      <td><a href="member_detail.php?id=<?php echo $m['id']; ?>"><?php echo htmlspecialchars($m['name']); ?></a></td>
      <td><?php echo htmlspecialchars($m['group']); ?></td>
      <td>
        <?php if ($m['role'] !== '役職なし'): ?>
          <span class="badge bg-primary"><?php echo htmlspecialchars($m['role']); ?></span>
        <?php else: ?>
          <span class="text-muted">—</span>
        <?php endif; ?>
      </td>
      <td><?php echo htmlspecialchars($m['phone']); ?></td>
      <td class="text-end">
        <a href="member_detail.php?id=<?php echo $m['id']; ?>" class="btn btn-sm btn-outline-secondary">詳細</a>
        <button class="btn btn-sm btn-outline-danger" type="button">削除</button>
      </td>
    </tr>
    <?php endforeach; ?>
  </tbody>
</table>

<?php require __DIR__ . '/includes/footer.php'; ?>
