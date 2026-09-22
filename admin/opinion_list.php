<?php
$pageTitle = 'ご意見管理';
require __DIR__ . '/includes/header.php';

$opinions = [
    ['date' => '2026-07-02', 'author' => '匿名', 'text' => '夜間のゴミ出しをやめてほしいです。'],
    ['date' => '2026-06-28', 'author' => '鈴木 花子', 'text' => '掲示板の場所を増やしてほしいです。'],
];
?>

<table class="table table-hover bg-white align-middle">
  <thead>
    <tr><th>投稿日</th><th>投稿者</th><th>内容</th></tr>
  </thead>
  <tbody>
    <?php foreach ($opinions as $o): ?>
    <tr>
      <td class="text-nowrap"><?php echo htmlspecialchars($o['date']); ?></td>
      <td class="text-nowrap"><?php echo htmlspecialchars($o['author']); ?></td>
      <td><?php echo htmlspecialchars($o['text']); ?></td>
    </tr>
    <?php endforeach; ?>
  </tbody>
</table>

<?php require __DIR__ . '/includes/footer.php'; ?>
