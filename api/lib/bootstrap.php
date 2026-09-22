<?php
// 全エンドポイント共通のヘッダー設定とCORS対応。各エンドポイントの先頭でrequireする。
// 開発中はAccess-Control-Allow-Originを*にしているが、本番では許可するオリジンを限定すること。

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Authorization, Content-Type');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

require_once __DIR__ . '/Database.php';
require_once __DIR__ . '/response.php';
