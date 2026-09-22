<?php $pageTitle = 'ログイン'; ?>
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
      <form action="index.php" method="post">
        <div class="mb-3">
          <label class="form-label">管理者ID</label>
          <input type="text" class="form-control" name="admin_id" placeholder="管理者IDを入力">
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
