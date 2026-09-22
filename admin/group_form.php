<?php
require_once __DIR__ . '/includes/Database.php';
require_once __DIR__ . '/includes/auth.php';
$pdo = Database::connection();

$error = null;
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = trim($_POST['name'] ?? '');
    $isActive = isset($_POST['active']) ? 1 : 0;

    if ($name !== '') {
        $maxOrder = (int) $pdo->query('SELECT COALESCE(MAX(sort_order), 0) FROM member_groups')->fetchColumn();
        $stmt = $pdo->prepare('INSERT INTO member_groups (name, sort_order, is_active) VALUES (:name, :sort_order, :is_active)');
        $stmt->execute(['name' => $name, 'sort_order' => $maxOrder + 1, 'is_active' => $isActive]);
        header('Location: group_list.php');
        exit;
    }
    $error = 'グループ名は必須です';
}

$pageTitle = 'グループ新規登録';
require __DIR__ . '/includes/header.php';
?>

<form action="group_form.php" method="post" class="bg-white p-4 rounded shadow-sm" style="max-width:480px;">
  <?php if ($error): ?>
    <div class="alert alert-danger py-2 small"><?php echo htmlspecialchars($error); ?></div>
  <?php endif; ?>
  <div class="mb-3">
    <label class="form-label">グループ名</label>
    <input type="text" class="form-control" name="name" placeholder="例）4組" value="<?php echo htmlspecialchars($_POST['name'] ?? ''); ?>">
  </div>
  <div class="mb-3 form-check form-switch">
    <input class="form-check-input" type="checkbox" role="switch" name="active" checked>
    <label class="form-check-label">有効フラグ</label>
  </div>
  <button type="submit" class="btn btn-primary">登録</button>
  <a href="group_list.php" class="btn btn-outline-secondary">キャンセル</a>
</form>

<?php require __DIR__ . '/includes/footer.php'; ?>
