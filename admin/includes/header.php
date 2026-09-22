<?php if (!isset($pageTitle)) { $pageTitle = '管理者画面'; } ?>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><?php echo htmlspecialchars($pageTitle); ?> | 町内会管理システム</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
  body { background-color: #f5f6f8; }
  .navbar-brand { font-weight: bold; }
  .table thead { background-color: #e9ecef; }
  .offcanvas-header { background-color: #0d6efd; color: #fff; }
  .offcanvas-header .btn-close { filter: invert(1); }
</style>
</head>
<body>

<nav class="navbar navbar-dark bg-primary mb-4">
  <div class="container-fluid">
    <button class="btn btn-outline-light me-2" type="button" data-bs-toggle="offcanvas" data-bs-target="#sideMenu" aria-controls="sideMenu">
      <span class="navbar-toggler-icon"></span>
    </button>
    <span class="navbar-brand mb-0 h1">町内会管理システム（管理者）</span>
  </div>
</nav>

<?php include __DIR__ . '/menu.php'; ?>

<div class="container-fluid px-4">
  <h2 class="mb-4"><?php echo htmlspecialchars($pageTitle); ?></h2>
