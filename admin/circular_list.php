<?php
$pageTitle = '回覧板管理';
require __DIR__ . '/includes/header.php';

$circulars = [
    ['id' => 1, 'title' => '自治会費集金のお知らせ', 'period' => '2026/07/01〜2026/07/31', 'read' => 18, 'total' => 25],
    ['id' => 2, 'title' => '資源ごみ回収カレンダー', 'period' => '2026/06/01〜2026/06/30', 'read' => 25, 'total' => 25],
];
?>

<div class="d-flex justify-content-end mb-3">
  <a href="circular_form.php" class="btn btn-primary">+ 新規登録</a>
</div>

<table class="table table-hover bg-white align-middle">
  <thead>
    <tr><th>タイトル</th><th>掲載期間</th><th>既読状況</th><th class="text-end">操作</th></tr>
  </thead>
  <tbody>
    <?php foreach ($circulars as $c): ?>
    <tr>
      <td><?php echo htmlspecialchars($c['title']); ?></td>
      <td><?php echo htmlspecialchars($c['period']); ?></td>
      <td>
        <a href="circular_read_status.php?id=<?php echo $c['id']; ?>"><?php echo $c['read']; ?> / <?php echo $c['total']; ?> 人既読</a>
      </td>
      <td class="text-end">
        <button class="btn btn-sm btn-outline-danger" type="button">削除</button>
      </td>
    </tr>
    <?php endforeach; ?>
  </tbody>
</table>

<?php require __DIR__ . '/includes/footer.php'; ?>
