<?php
$pageTitle = 'チャット管理';
require __DIR__ . '/includes/header.php';

$rooms = ['全体チャット', '佐藤 太郎さんとのチャット', '鈴木 花子さんとのチャット'];
$selected = $_GET['room'] ?? $rooms[0];
$messages = [
    ['sender' => '佐藤 太郎', 'text' => '来週の掃除当番の件で質問です。', 'time' => '09:12'],
    ['sender' => '会長', 'text' => '土曜9時から集合でお願いします。', 'time' => '09:20'],
];
?>

<div class="row">
  <div class="col-md-3 mb-3">
    <div class="list-group">
      <?php foreach ($rooms as $r): ?>
        <a href="chat_list.php?room=<?php echo urlencode($r); ?>"
           class="list-group-item list-group-item-action <?php echo $r === $selected ? 'active' : ''; ?>">
          <?php echo htmlspecialchars($r); ?>
        </a>
      <?php endforeach; ?>
    </div>
  </div>
  <div class="col-md-9">
    <div class="bg-white p-3 rounded shadow-sm mb-3" style="min-height:300px;">
      <p class="text-muted mb-3"><?php echo htmlspecialchars($selected); ?></p>
      <?php foreach ($messages as $m): ?>
        <div class="d-flex justify-content-between border-bottom py-2">
          <div><strong><?php echo htmlspecialchars($m['sender']); ?></strong>：<?php echo htmlspecialchars($m['text']); ?></div>
          <div class="text-nowrap ms-2">
            <span class="text-muted small me-2"><?php echo htmlspecialchars($m['time']); ?></span>
            <button class="btn btn-sm btn-outline-danger" type="button">削除</button>
          </div>
        </div>
      <?php endforeach; ?>
    </div>
  </div>
</div>

<?php require __DIR__ . '/includes/footer.php'; ?>
