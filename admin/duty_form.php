<?php
require_once __DIR__ . '/includes/Database.php';
require_once __DIR__ . '/includes/auth.php';
$pdo = Database::connection();

$editMode = isset($_GET['id']);
$id = $editMode ? (int) $_GET['id'] : null;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $month = $_POST['month'] ?? '';
    $memberId = $_POST['member_id'] !== '' ? (int) $_POST['member_id'] : null;
    $postedId = isset($_POST['id']) && $_POST['id'] !== '' ? (int) $_POST['id'] : null;

    if ($month !== '' && $memberId) {
        $monthDate = $month . '-01';
        if ($postedId) {
            $stmt = $pdo->prepare('UPDATE garbage_duties SET month=:month, member_id=:member_id WHERE id=:id');
            $stmt->execute(['month' => $monthDate, 'member_id' => $memberId, 'id' => $postedId]);
        } else {
            $stmt = $pdo->prepare('INSERT INTO garbage_duties (month, member_id) VALUES (:month, :member_id)');
            $stmt->execute(['month' => $monthDate, 'member_id' => $memberId]);
        }
        header('Location: duty_list.php');
        exit;
    }
    $error = '対象月と担当者は必須です（同じ月はすでに登録されている可能性があります）';
    $data = ['month' => $month, 'member_id' => $memberId];
} elseif ($editMode) {
    $stmt = $pdo->prepare('SELECT month, member_id FROM garbage_duties WHERE id = :id');
    $stmt->execute(['id' => $id]);
    $row = $stmt->fetch();
    if (!$row) {
        header('Location: duty_list.php');
        exit;
    }
    $data = ['month' => substr($row['month'], 0, 7), 'member_id' => $row['member_id']];
} else {
    $data = ['month' => '', 'member_id' => null];
}

$pageTitle = $editMode ? 'ゴミ当番編集' : 'ゴミ当番新規登録';
require __DIR__ . '/includes/header.php';

$members = $pdo->query(
    "SELECT m.id, m.name, g.name AS group_name
     FROM members m LEFT JOIN member_groups g ON g.id = m.group_id
     ORDER BY g.sort_order, m.name"
)->fetchAll();
?>

<form action="duty_form.php<?php echo $editMode ? '?id=' . $id : ''; ?>" method="post" class="bg-white p-4 rounded shadow-sm" style="max-width:480px;">
  <?php if (!empty($error)): ?>
    <div class="alert alert-danger py-2 small"><?php echo htmlspecialchars($error); ?></div>
  <?php endif; ?>
  <?php if ($editMode): ?>
    <input type="hidden" name="id" value="<?php echo $id; ?>">
  <?php endif; ?>
  <div class="mb-3">
    <label class="form-label">対象月</label>
    <input type="month" class="form-control" name="month" value="<?php echo htmlspecialchars($data['month']); ?>">
  </div>
  <div class="mb-3">
    <label class="form-label">担当者</label>
    <select class="form-select" name="member_id">
      <option value="">選択してください</option>
      <?php foreach ($members as $m): ?>
        <option value="<?php echo $m['id']; ?>" <?php echo (int) $data['member_id'] === (int) $m['id'] ? 'selected' : ''; ?>>
          <?php echo htmlspecialchars($m['name']); ?>（<?php echo htmlspecialchars($m['group_name'] ?? '未所属'); ?>）
        </option>
      <?php endforeach; ?>
    </select>
    <div class="form-text">会員一覧から担当者を選択します。組単位ではなく個人単位での割り当てです。</div>
  </div>
  <button type="submit" class="btn btn-primary"><?php echo $editMode ? '更新' : '登録'; ?></button>
  <a href="duty_list.php" class="btn btn-outline-secondary">キャンセル</a>
</form>

<?php require __DIR__ . '/includes/footer.php'; ?>
