<?php
require_once __DIR__ . '/includes/Database.php';
require_once __DIR__ . '/includes/auth.php';
$pdo = Database::connection();

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['_action'] ?? '') === 'delete') {
    $stmt = $pdo->prepare('DELETE FROM chat_messages WHERE id = :id');
    $stmt->execute(['id' => (int) $_POST['message_id']]);
    $redirect = 'chat_list.php';
    if (isset($_POST['room'])) {
        $redirect .= '?room=' . urlencode($_POST['room']);
    }
    header('Location: ' . $redirect);
    exit;
}

$pageTitle = 'チャット管理';
require __DIR__ . '/includes/header.php';

// 管理者はチャットの当事者ではなく閲覧・削除のみ（個別チャットは「会員 ⇔ その組の組長」）。
// 個別チャットのルームは、実際にやり取りが発生している会員から動的に一覧化する。
$leaderThreads = $pdo->query(
    "SELECT DISTINCT m.id, m.name, g.name AS group_name
     FROM chat_messages cm
     JOIN members m ON m.id = cm.member_id
     LEFT JOIN member_groups g ON g.id = m.group_id
     WHERE cm.room_type = 'leader_dm'
     ORDER BY m.name"
)->fetchAll();

$selectedRoom = $_GET['room'] ?? 'all';

function leader_name_for_group(PDO $pdo, ?string $groupName): ?string
{
    if (!$groupName) {
        return null;
    }
    $stmt = $pdo->prepare(
        "SELECT m.name FROM members m JOIN member_groups g ON g.id = m.group_id
         WHERE g.name = :group_name AND m.role = 'leader' LIMIT 1"
    );
    $stmt->execute(['group_name' => $groupName]);
    return $stmt->fetchColumn() ?: null;
}

if ($selectedRoom === 'all') {
    $roomLabel = '全体チャット';
    $stmt = $pdo->query(
        "SELECT cm.id, cm.body, cm.created_at, cm.sender_is_admin,
                COALESCE(m.name, '事務局') AS sender_name
         FROM chat_messages cm
         LEFT JOIN members m ON m.id = cm.sender_member_id
         WHERE cm.room_type = 'all'
         ORDER BY cm.created_at"
    );
    $messages = $stmt->fetchAll();
} else {
    $memberId = (int) $selectedRoom;
    $stmt = $pdo->prepare('SELECT name, group_id FROM members WHERE id = :id');
    $stmt->execute(['id' => $memberId]);
    $member = $stmt->fetch();

    if (!$member) {
        header('Location: chat_list.php');
        exit;
    }

    $groupStmt = $pdo->prepare('SELECT name FROM member_groups WHERE id = :id');
    $groupStmt->execute(['id' => $member['group_id']]);
    $groupName = $groupStmt->fetchColumn() ?: null;
    $leaderName = leader_name_for_group($pdo, $groupName);

    $roomLabel = $member['name'] . 'さん ⇔ ' . ($groupName ?? '未所属') . 'の組長'
        . ($leaderName ? '（' . $leaderName . '）' : '（未設定）');

    $stmt = $pdo->prepare(
        "SELECT cm.id, cm.body, cm.created_at, cm.sender_is_admin,
                COALESCE(m.name, '事務局') AS sender_name
         FROM chat_messages cm
         LEFT JOIN members m ON m.id = cm.sender_member_id
         WHERE cm.room_type = 'leader_dm' AND cm.member_id = :member_id
         ORDER BY cm.created_at"
    );
    $stmt->execute(['member_id' => $memberId]);
    $messages = $stmt->fetchAll();
}
?>

<div class="row">
  <div class="col-md-3 mb-3">
    <div class="list-group">
      <a href="chat_list.php?room=all" class="list-group-item list-group-item-action <?php echo $selectedRoom === 'all' ? 'active' : ''; ?>">
        全体チャット
      </a>
      <?php foreach ($leaderThreads as $t): ?>
        <a href="chat_list.php?room=<?php echo $t['id']; ?>"
           class="list-group-item list-group-item-action <?php echo (string) $selectedRoom === (string) $t['id'] ? 'active' : ''; ?>">
          <?php echo htmlspecialchars($t['name']); ?>さん
          <div class="small <?php echo (string) $selectedRoom === (string) $t['id'] ? 'text-white-50' : 'text-muted'; ?>">
            <?php echo htmlspecialchars($t['group_name'] ?? '未所属'); ?>の組長とのチャット
          </div>
        </a>
      <?php endforeach; ?>
    </div>
  </div>
  <div class="col-md-9">
    <div class="bg-white p-3 rounded shadow-sm mb-3" style="min-height:300px;">
      <p class="text-muted mb-3"><?php echo htmlspecialchars($roomLabel); ?></p>
      <?php foreach ($messages as $m): ?>
        <div class="d-flex justify-content-between border-bottom py-2">
          <div><strong><?php echo htmlspecialchars($m['sender_name']); ?></strong>：<?php echo htmlspecialchars($m['body']); ?></div>
          <div class="text-nowrap ms-2">
            <span class="text-muted small me-2"><?php echo htmlspecialchars($m['created_at']); ?></span>
            <form action="chat_list.php" method="post" class="d-inline" onsubmit="return confirm('削除しますか？');">
              <input type="hidden" name="_action" value="delete">
              <input type="hidden" name="message_id" value="<?php echo $m['id']; ?>">
              <input type="hidden" name="room" value="<?php echo htmlspecialchars($selectedRoom); ?>">
              <button class="btn btn-sm btn-outline-danger" type="submit">削除</button>
            </form>
          </div>
        </div>
      <?php endforeach; ?>
      <?php if (!$messages): ?>
        <p class="text-center text-muted py-4 mb-0">メッセージがありません</p>
      <?php endif; ?>
    </div>
  </div>
</div>

<?php require __DIR__ . '/includes/footer.php'; ?>
