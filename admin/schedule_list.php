<?php
$pageTitle = 'スケジュール管理';
require __DIR__ . '/includes/header.php';

$schedules = [
    ['id' => 1, 'date' => '2026-07-05', 'title' => '資源ごみ回収'],
    ['id' => 2, 'date' => '2026-07-20', 'title' => '夏祭り実行委員会'],
    ['id' => 3, 'date' => '2026-08-01', 'title' => '夏祭り'],
];
?>

<div class="d-flex justify-content-end mb-3">
  <a href="schedule_form.php" class="btn btn-primary">+ 新規登録</a>
</div>

<table class="table table-hover bg-white align-middle">
  <thead>
    <tr><th>日付</th><th>タイトル</th><th class="text-end">操作</th></tr>
  </thead>
  <tbody>
    <?php foreach ($schedules as $s): ?>
    <tr>
      <td><?php echo htmlspecialchars($s['date']); ?></td>
      <td><?php echo htmlspecialchars($s['title']); ?></td>
      <td class="text-end">
        <a href="schedule_form.php?id=<?php echo $s['id']; ?>" class="btn btn-sm btn-outline-secondary">編集</a>
        <button class="btn btn-sm btn-outline-danger" type="button">削除</button>
      </td>
    </tr>
    <?php endforeach; ?>
  </tbody>
</table>

<?php require __DIR__ . '/includes/footer.php'; ?>
