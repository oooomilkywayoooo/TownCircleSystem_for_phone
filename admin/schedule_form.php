<?php
require_once __DIR__ . '/includes/Database.php';
require_once __DIR__ . '/includes/auth.php';
$pdo = Database::connection();

$editMode = isset($_GET['id']);
$id = $editMode ? (int) $_GET['id'] : null;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $date = $_POST['date'] ?? '';
    $title = trim($_POST['title'] ?? '');
    $detail = trim($_POST['detail'] ?? '');
    $postedId = isset($_POST['id']) && $_POST['id'] !== '' ? (int) $_POST['id'] : null;

    if ($date !== '' && $title !== '') {
        if ($postedId) {
            $stmt = $pdo->prepare('UPDATE schedules SET date=:date, title=:title, detail=:detail WHERE id=:id');
            $stmt->execute(['date' => $date, 'title' => $title, 'detail' => $detail ?: null, 'id' => $postedId]);
        } else {
            $stmt = $pdo->prepare('INSERT INTO schedules (date, title, detail) VALUES (:date, :title, :detail)');
            $stmt->execute(['date' => $date, 'title' => $title, 'detail' => $detail ?: null]);
        }
        header('Location: schedule_list.php');
        exit;
    }
    $error = '日付とタイトルは必須です';
    $data = ['date' => $date, 'title' => $title, 'detail' => $detail];
} elseif ($editMode) {
    $stmt = $pdo->prepare('SELECT date, title, detail FROM schedules WHERE id = :id');
    $stmt->execute(['id' => $id]);
    $row = $stmt->fetch();
    if (!$row) {
        header('Location: schedule_list.php');
        exit;
    }
    $data = ['date' => $row['date'], 'title' => $row['title'], 'detail' => $row['detail'] ?? ''];
} else {
    $data = ['date' => '', 'title' => '', 'detail' => ''];
}

$pageTitle = $editMode ? 'スケジュール編集' : 'スケジュール新規登録';
require __DIR__ . '/includes/header.php';
?>

<form action="schedule_form.php<?php echo $editMode ? '?id=' . $id : ''; ?>" method="post" class="bg-white p-4 rounded shadow-sm" style="max-width:560px;">
  <?php if (!empty($error)): ?>
    <div class="alert alert-danger py-2 small"><?php echo htmlspecialchars($error); ?></div>
  <?php endif; ?>
  <?php if ($editMode): ?>
    <input type="hidden" name="id" value="<?php echo $id; ?>">
  <?php endif; ?>
  <div class="mb-3">
    <label class="form-label">日付</label>
    <input type="date" class="form-control" name="date" value="<?php echo htmlspecialchars($data['date']); ?>">
  </div>
  <div class="mb-3">
    <label class="form-label">タイトル</label>
    <input type="text" class="form-control" name="title" value="<?php echo htmlspecialchars($data['title']); ?>">
  </div>
  <div class="mb-3">
    <label class="form-label">詳細</label>
    <textarea class="form-control" name="detail" rows="4"><?php echo htmlspecialchars($data['detail']); ?></textarea>
  </div>
  <button type="submit" class="btn btn-primary"><?php echo $editMode ? '更新' : '登録'; ?></button>
  <a href="schedule_list.php" class="btn btn-outline-secondary">キャンセル</a>
</form>

<?php require __DIR__ . '/includes/footer.php'; ?>
