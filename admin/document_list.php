<?php
$pageTitle = '資料管理';
require __DIR__ . '/includes/header.php';

$documents = [
    ['id' => 1, 'name' => '町内会規約.pdf', 'date' => '2026-04-01'],
    ['id' => 2, 'name' => '防災マニュアル.pdf', 'date' => '2026-05-10'],
];
?>

<div class="d-flex justify-content-end mb-3">
  <a href="document_form.php" class="btn btn-primary">+ 新規登録</a>
</div>

<table class="table table-hover bg-white align-middle">
  <thead>
    <tr><th>資料名</th><th>アップロード日</th><th class="text-end">操作</th></tr>
  </thead>
  <tbody>
    <?php foreach ($documents as $d): ?>
    <tr>
      <td><?php echo htmlspecialchars($d['name']); ?></td>
      <td><?php echo htmlspecialchars($d['date']); ?></td>
      <td class="text-end">
        <a href="#" class="btn btn-sm btn-outline-secondary">ダウンロード</a>
        <button class="btn btn-sm btn-outline-danger" type="button">削除</button>
      </td>
    </tr>
    <?php endforeach; ?>
  </tbody>
</table>

<?php require __DIR__ . '/includes/footer.php'; ?>
