<?php
require_once __DIR__ . '/includes/Database.php';

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

$pageTitle = 'ログイン';
$error = null;

if (!empty($_SESSION['admin_id'])) {
    header('Location: index.php');
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $adminId = trim($_POST['admin_id'] ?? '');
    $password = (string) ($_POST['password'] ?? '');

    if ($adminId === '' || $password === '') {
        $error = '管理者IDとパスワードを入力してください';
    } else {
        $pdo = Database::connection();
        $stmt = $pdo->prepare('SELECT * FROM admins WHERE login_id = :login_id');
        $stmt->execute(['login_id' => $adminId]);
        $admin = $stmt->fetch();

        if (!$admin || !password_verify($password, $admin['password_hash'])) {
            $error = '管理者IDまたはパスワードが違います';
        } else {
            session_regenerate_id(true);
            $_SESSION['admin_id'] = (int) $admin['id'];
            $_SESSION['admin_name'] = $admin['name'];
            $_SESSION['last_activity'] = time();
            header('Location: index.php');
            exit;
        }
    }
}

$timedOut = isset($_GET['timeout']);
?>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><?php echo htmlspecialchars($pageTitle); ?> | 町内会管理システム</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="d-flex align-items-center justify-content-center vh-100">
  <div class="card shadow-sm" style="width: 360px;">
    <div class="card-body p-4">
      <h4 class="text-center mb-4">町内会管理システム</h4>
      <?php if ($timedOut): ?>
        <div class="alert alert-warning py-2 small">一定時間操作がなかったため、自動的にログアウトしました。</div>
      <?php endif; ?>
      <?php if ($error): ?>
        <div class="alert alert-danger py-2 small"><?php echo htmlspecialchars($error); ?></div>
      <?php endif; ?>
      <form action="login.php" method="post">
        <div class="mb-3">
          <label class="form-label">管理者ID</label>
          <input type="text" class="form-control" name="admin_id" placeholder="管理者IDを入力" value="<?php echo htmlspecialchars($_POST['admin_id'] ?? ''); ?>">
        </div>
        <div class="mb-3">
          <label class="form-label">パスワード</label>
          <input type="password" class="form-control" name="password" placeholder="パスワードを入力">
        </div>
        <button type="submit" class="btn btn-primary w-100">ログイン</button>
      </form>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
