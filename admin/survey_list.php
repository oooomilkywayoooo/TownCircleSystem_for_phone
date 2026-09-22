<?php
$pageTitle = 'アンケート管理';
require __DIR__ . '/includes/header.php';

$surveys = [
    ['id' => 1, 'title' => '夏祭りに関するアンケート', 'url' => 'https://forms.gle/example1', 'date' => '2026-06-10'],
    ['id' => 2, 'title' => '町内会運営に関するご意見募集', 'url' => 'https://forms.gle/example2', 'date' => '2026-05-01'],
];
?>

<div class="d-flex justify-content-end mb-3">
  <a href="survey_form.php" class="btn btn-primary">+ 新規登録</a>
</div>

<table class="table table-hover bg-white align-middle">
  <thead>
    <tr><th>タイトル</th><th>Googleフォーム</th><th>作成日</th><th class="text-end">操作</th></tr>
  </thead>
  <tbody>
    <?php foreach ($surveys as $s): ?>
    <tr>
      <td><?php echo htmlspecialchars($s['title']); ?></td>
      <td><a href="<?php echo htmlspecialchars($s['url']); ?>" target="_blank" rel="noopener">フォームを開く</a></td>
      <td><?php echo htmlspecialchars($s['date']); ?></td>
      <td class="text-end">
        <button class="btn btn-sm btn-outline-danger" type="button">削除</button>
      </td>
    </tr>
    <?php endforeach; ?>
  </tbody>
</table>

<?php require __DIR__ . '/includes/footer.php'; ?>
