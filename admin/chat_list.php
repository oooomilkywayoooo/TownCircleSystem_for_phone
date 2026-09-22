<?php
$pageTitle = 'チャット管理';
require __DIR__ . '/includes/header.php';

// 会員管理と同じダミーデータ。個別チャットの相手（組長）はここから動的に解決する。
$members = [
    ['id' => 1, 'name' => '佐藤 太郎', 'group' => '1組', 'role' => '組長'],
    ['id' => 2, 'name' => '鈴木 花子', 'group' => '2組', 'role' => '役職なし'],
    ['id' => 3, 'name' => '高橋 次郎', 'group' => '1組', 'role' => '副組長'],
];

function leader_name_for_group(array $members, string $group): ?string
{
    foreach ($members as $m) {
        if ($m['group'] === $group && $m['role'] === '組長') {
            return $m['name'];
        }
    }
    return null;
}

// 管理者はチャットの当事者ではなく閲覧・削除のみ（個別チャットは「会員 ⇔ その組の組長」）。
// 全体チャット以外は、実際には「組長とのチャットを行っている会員」ごとに動的なリストになる想定。
$rooms = [
    ['type' => 'all', 'label' => '全体チャット'],
    ['type' => 'member', 'member' => '高橋 次郎', 'group' => '1組'],
    ['type' => 'member', 'member' => '鈴木 花子', 'group' => '2組'],
];

$selectedIndex = isset($_GET['room']) ? (int) $_GET['room'] : 0;
if ($selectedIndex < 0 || $selectedIndex >= count($rooms)) {
    $selectedIndex = 0;
}
$selectedRoom = $rooms[$selectedIndex];

if ($selectedRoom['type'] === 'all') {
    $roomLabel = $selectedRoom['label'];
    $messages = [
        ['sender' => '事務局', 'text' => '来週の町内清掃活動は9/27（日）朝8時からです。', 'time' => '09/20 10:02'],
        ['sender' => '鈴木 花子', 'text' => '承知しました、参加します。', 'time' => '09/20 10:15'],
        ['sender' => '佐藤 太郎', 'text' => '軍手を持参いただけると助かります。', 'time' => '09/20 10:20'],
    ];
} else {
    $leaderName = leader_name_for_group($members, $selectedRoom['group']);
    $roomLabel = $selectedRoom['member'] . 'さん ⇔ ' . $selectedRoom['group'] . 'の組長'
        . ($leaderName ? '（' . $leaderName . '）' : '（未設定）');
    $messages = $selectedRoom['member'] === '高橋 次郎'
        ? [
            ['sender' => '高橋 次郎', 'text' => '来月の資源ごみ回収、当番表の確認をお願いします。', 'time' => '09/21 14:10'],
            ['sender' => $leaderName ?? '組長', 'text' => '確認しました、ありがとうございます。', 'time' => '09/21 15:00'],
        ]
        : [
            ['sender' => '鈴木 花子', 'text' => '来週の集金、何時頃になりますか？', 'time' => '09/19 11:00'],
        ];
}
?>

<div class="row">
  <div class="col-md-3 mb-3">
    <div class="list-group">
      <?php foreach ($rooms as $index => $r): ?>
        <a href="chat_list.php?room=<?php echo $index; ?>"
           class="list-group-item list-group-item-action <?php echo $index === $selectedIndex ? 'active' : ''; ?>">
          <?php if ($r['type'] === 'all'): ?>
            <?php echo htmlspecialchars($r['label']); ?>
          <?php else: ?>
            <?php echo htmlspecialchars($r['member']); ?>さん
            <div class="small <?php echo $index === $selectedIndex ? 'text-white-50' : 'text-muted'; ?>"><?php echo htmlspecialchars($r['group']); ?>の組長とのチャット</div>
          <?php endif; ?>
        </a>
      <?php endforeach; ?>
    </div>
  </div>
  <div class="col-md-9">
    <div class="bg-white p-3 rounded shadow-sm mb-3" style="min-height:300px;">
      <p class="text-muted mb-3"><?php echo htmlspecialchars($roomLabel); ?></p>
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
