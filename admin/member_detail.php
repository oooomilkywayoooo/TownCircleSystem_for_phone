<?php
require_once __DIR__ . '/includes/Database.php';
require_once __DIR__ . '/includes/auth.php';
$pdo = Database::connection();

$id = (int) ($_GET['id'] ?? 0);

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['_action'] ?? '') === 'update') {
    $groupId = $_POST['group_id'] !== '' ? (int) $_POST['group_id'] : null;
    $role = $_POST['role'] ?? 'none';
    $stmt = $pdo->prepare('UPDATE members SET group_id = :group_id, role = :role WHERE id = :id');
    $stmt->execute(['group_id' => $groupId, 'role' => $role, 'id' => $id]);
    header('Location: member_detail.php?id=' . $id);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['_action'] ?? '') === 'delete') {
    $stmt = $pdo->prepare('DELETE FROM members WHERE id = :id');
    $stmt->execute(['id' => $id]);
    header('Location: member_list.php');
    exit;
}

$stmt = $pdo->prepare(
    'SELECT m.*, g.name AS group_name FROM members m LEFT JOIN member_groups g ON g.id = m.group_id WHERE m.id = :id'
);
$stmt->execute(['id' => $id]);
$member = $stmt->fetch();

if (!$member) {
    header('Location: member_list.php');
    exit;
}

$pageTitle = '会員詳細';
require __DIR__ . '/includes/header.php';

$groups = $pdo->query('SELECT id, name FROM member_groups ORDER BY sort_order')->fetchAll();
$roles = ['none' => '役職なし', 'leader' => '組長', 'vice_leader' => '副組長'];
?>

<div class="bg-white p-4 rounded shadow-sm mb-4" style="max-width:640px;">
  <dl class="row mb-0">
    <dt class="col-sm-3">氏名</dt><dd class="col-sm-9"><?php echo htmlspecialchars($member['name']); ?></dd>
    <dt class="col-sm-3">住所</dt><dd class="col-sm-9"><?php echo htmlspecialchars($member['address']); ?></dd>
    <dt class="col-sm-3">電話番号</dt><dd class="col-sm-9"><?php echo htmlspecialchars($member['phone']); ?></dd>
    <dt class="col-sm-3">メールアドレス</dt><dd class="col-sm-9"><?php echo htmlspecialchars($member['email']); ?></dd>
    <dt class="col-sm-3">家族人数</dt><dd class="col-sm-9"><?php echo (int) $member['family_count']; ?>人</dd>
    <dt class="col-sm-3">グループ</dt><dd class="col-sm-9"><?php echo htmlspecialchars($member['group_name'] ?? '未所属'); ?></dd>
    <dt class="col-sm-3">役職</dt>
    <dd class="col-sm-9">
      <?php if ($member['role'] !== 'none'): ?>
        <span class="badge bg-primary"><?php echo htmlspecialchars($roles[$member['role']]); ?></span>
      <?php else: ?>
        <span class="text-muted">役職なし</span>
      <?php endif; ?>
    </dd>
  </dl>
</div>

<form action="member_detail.php?id=<?php echo $id; ?>" method="post" class="bg-white p-4 rounded shadow-sm mb-4" style="max-width:480px;">
  <input type="hidden" name="_action" value="update">
  <div class="mb-3">
    <label class="form-label">グループ変更</label>
    <select class="form-select" name="group_id">
      <?php foreach ($groups as $g): ?>
        <option value="<?php echo $g['id']; ?>" <?php echo (int) $member['group_id'] === (int) $g['id'] ? 'selected' : ''; ?>>
          <?php echo htmlspecialchars($g['name']); ?>
        </option>
      <?php endforeach; ?>
    </select>
  </div>
  <div class="mb-3">
    <label class="form-label">役職</label>
    <select class="form-select" name="role">
      <?php foreach ($roles as $value => $label): ?>
        <option value="<?php echo $value; ?>" <?php echo $member['role'] === $value ? 'selected' : ''; ?>>
          <?php echo htmlspecialchars($label); ?>
        </option>
      <?php endforeach; ?>
    </select>
    <div class="form-text">同じ組で「組長」「副組長」に設定できるのはそれぞれ1名までを想定しています。</div>
  </div>
  <button type="submit" class="btn btn-primary">変更</button>
</form>

<div class="d-flex gap-2">
  <a href="mailto:<?php echo htmlspecialchars($member['email']); ?>" class="btn btn-outline-primary">連絡する</a>
  <form action="member_detail.php?id=<?php echo $id; ?>" method="post" onsubmit="return confirm('この会員を削除しますか？');">
    <input type="hidden" name="_action" value="delete">
    <button class="btn btn-outline-danger" type="submit">この会員を削除</button>
  </form>
  <a href="member_list.php" class="btn btn-outline-secondary">一覧へ戻る</a>
</div>

<?php require __DIR__ . '/includes/footer.php'; ?>
