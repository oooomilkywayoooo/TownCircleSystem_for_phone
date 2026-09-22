<?php
require_once __DIR__ . '/includes/Database.php';
require_once __DIR__ . '/includes/auth.php';
$pdo = Database::connection();

$id = (int) ($_GET['id'] ?? 0);

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['_action'] ?? '') === 'toggle_active') {
    $isActive = isset($_POST['is_active']) ? 1 : 0;
    $stmt = $pdo->prepare('UPDATE member_groups SET is_active = :is_active WHERE id = :id');
    $stmt->execute(['is_active' => $isActive, 'id' => $id]);
    header('Location: group_detail.php?id=' . $id);
    exit;
}

$stmt = $pdo->prepare('SELECT id, name, is_active FROM member_groups WHERE id = :id');
$stmt->execute(['id' => $id]);
$group = $stmt->fetch();

if (!$group) {
    header('Location: group_list.php');
    exit;
}

$pageTitle = 'グループ詳細';
require __DIR__ . '/includes/header.php';

$stmt = $pdo->prepare(
    'SELECT name, phone FROM members WHERE group_id = :group_id ORDER BY name'
);
$stmt->execute(['group_id' => $id]);
$members = $stmt->fetchAll();
?>

<div class="bg-white p-4 rounded shadow-sm mb-4" style="max-width:640px;">
  <dl class="row mb-0">
    <dt class="col-sm-3">グループ名</dt>
    <dd class="col-sm-9"><?php echo htmlspecialchars($group['name']); ?></dd>
    <dt class="col-sm-3">状態</dt>
    <dd class="col-sm-9">
      <form action="group_detail.php?id=<?php echo $id; ?>" method="post" onchange="this.submit()">
        <input type="hidden" name="_action" value="toggle_active">
        <div class="form-check form-switch">
          <input class="form-check-input" type="checkbox" role="switch" name="is_active" <?php echo $group['is_active'] ? 'checked' : ''; ?>>
          <label class="form-check-label">有効フラグ</label>
        </div>
      </form>
    </dd>
  </dl>
</div>

<h5>所属会員</h5>
<table class="table table-hover bg-white align-middle">
  <thead>
    <tr><th>氏名</th><th>電話番号</th></tr>
  </thead>
  <tbody>
    <?php foreach ($members as $m): ?>
    <tr>
      <td><?php echo htmlspecialchars($m['name']); ?></td>
      <td><?php echo htmlspecialchars($m['phone']); ?></td>
    </tr>
    <?php endforeach; ?>
    <?php if (!$members): ?>
    <tr><td colspan="2" class="text-center text-muted py-4">所属会員がいません</td></tr>
    <?php endif; ?>
  </tbody>
</table>

<a href="group_list.php" class="btn btn-outline-secondary">一覧へ戻る</a>

<?php require __DIR__ . '/includes/footer.php'; ?>
