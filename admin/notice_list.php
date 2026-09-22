<?php
$pageTitle = 'お知らせ管理';
require __DIR__ . '/includes/header.php';

$notices = [
    ['id' => 1, 'title' => '夏祭りのお知らせ', 'date' => '2026-07-01'],
    ['id' => 2, 'title' => '防災訓練について', 'date' => '2026-06-15'],
    ['id' => 3, 'title' => 'ゴミ収集日変更のお知らせ', 'date' => '2026-05-20'],
];
?>

<div class="d-flex justify-content-end mb-3">
  <a href="notice_form.php" class="btn btn-primary">+ 新規登録</a>
</div>

<table class="table table-hover bg-white align-middle">
  <thead>
    <tr><th>タイトル</th><th>投稿日</th><th class="text-end">操作</th></tr>
  </thead>
  <tbody>
    <?php foreach ($notices as $n): ?>
    <tr>
      <td><?php echo htmlspecialchars($n['title']); ?></td>
      <td><?php echo htmlspecialchars($n['date']); ?></td>
      <td class="text-end">
        <a href="notice_form.php?id=<?php echo $n['id']; ?>" class="btn btn-sm btn-outline-secondary">編集</a>
        <button class="btn btn-sm btn-outline-danger" type="button">削除</button>
      </td>
    </tr>
    <?php endforeach; ?>
  </tbody>
</table>

<?php require __DIR__ . '/includes/footer.php'; ?>
