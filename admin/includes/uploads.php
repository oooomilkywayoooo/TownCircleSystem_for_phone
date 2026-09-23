<?php
// アップロードされたファイルを api/uploads/ 配下に保存するヘルパー。
// api/ 側のPHP内蔵サーバー（ポート8099）はドキュメントルート配下の静的ファイルをそのまま配信するため、
// ここに保存した画像はFlutterアプリからも http://<apiホスト>/uploads/... で読み込める。

define('UPLOADS_DIR', __DIR__ . '/../../api/uploads');

const ALLOWED_IMAGE_EXTENSIONS = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
const MAX_UPLOAD_BYTES = 5 * 1024 * 1024; // 5MB

/**
 * $_FILES['image'] のような1ファイル分の配列を受け取り、画像として検証してsubdir配下に保存する。
 * ファイルが選択されていない場合はnullを返す。DB保存用の相対パス（例: "circulars/xxxx.jpg"）を返す。
 * 検証エラー時はRuntimeExceptionを投げる。
 */
function save_uploaded_image(array $file, string $subdir): ?string
{
    if (!isset($file['error']) || $file['error'] === UPLOAD_ERR_NO_FILE) {
        return null;
    }
    if ($file['error'] !== UPLOAD_ERR_OK) {
        throw new RuntimeException('画像のアップロードに失敗しました');
    }
    if ($file['size'] > MAX_UPLOAD_BYTES) {
        throw new RuntimeException('画像のサイズは5MB以下にしてください');
    }

    $extension = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
    if (!in_array($extension, ALLOWED_IMAGE_EXTENSIONS, true)) {
        throw new RuntimeException('画像はjpg・png・gif・webpのいずれかにしてください');
    }

    $mimeType = mime_content_type($file['tmp_name']);
    if (!$mimeType || strpos($mimeType, 'image/') !== 0) {
        throw new RuntimeException('画像ファイルとして認識できませんでした');
    }

    $targetDir = UPLOADS_DIR . '/' . $subdir;
    if (!is_dir($targetDir) && !mkdir($targetDir, 0755, true) && !is_dir($targetDir)) {
        throw new RuntimeException('保存先ディレクトリを作成できませんでした');
    }

    $filename = bin2hex(random_bytes(16)) . '.' . $extension;
    $destination = $targetDir . '/' . $filename;

    if (!move_uploaded_file($file['tmp_name'], $destination)) {
        throw new RuntimeException('画像の保存に失敗しました');
    }

    return $subdir . '/' . $filename;
}
