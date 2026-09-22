<?php
// header.php の先頭から読み込む認証ガード。ログイン画面(login.php)は
// header.phpを使わない独立ページのため、このガードの対象にはならない。

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

$config = require __DIR__ . '/../config.php';
$timeoutSeconds = $config['session_timeout_minutes'] * 60;

if (empty($_SESSION['admin_id'])) {
    header('Location: login.php');
    exit;
}

// 一定時間操作がない場合の自動ログアウト
if (!empty($_SESSION['last_activity']) && (time() - $_SESSION['last_activity']) > $timeoutSeconds) {
    session_unset();
    session_destroy();
    header('Location: login.php?timeout=1');
    exit;
}

$_SESSION['last_activity'] = time();
