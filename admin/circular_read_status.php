<?php
$pageTitle = '回覧板 既読確認';
require __DIR__ . '/includes/header.php';

$members = [
    ['name' => '佐藤 太郎', 'group' => '1丁目班', 'read' => true],
    ['name' => '鈴木 花子', 'group' => '2丁目班', 'read' => true],
    ['name' => '高橋 次郎', 'group' => '1丁目班', 'read' => false],
    ['name' => '田中 三郎', 'group' => '3丁目班', 'read' => false],
];
?>

<p class="mb-3">対象回覧板：<strong>自治会費集金のお知らせ</strong></p>

<table class="table table-hover bg-white align-middle">
  <thead>
    <tr><th>氏名</th><th>グループ</th><th>既読状況</th></tr>
  </thead>
  <tbody>
    <?php foreach ($members as $m): ?>
    <tr>
      <td><?php echo htmlspecialchars($m['name']); ?></td>
      <td><?php echo htmlspecialchars($m['group']); ?></td>
      <td>
        <?php if ($m['read']): ?>
          <span class="badge bg-success">既読</span>
        <?php else: ?>
          <span class="badge bg-secondary">未読</span>
        <?php endif; ?>
      </td>
    </tr>
    <?php endforeach; ?>
  </tbody>
</table>

<a href="circular_list.php" class="btn btn-outline-secondary">一覧へ戻る</a>

<?php require __DIR__ . '/includes/footer.php'; ?>
