<?php

function json_ok($data, int $status = 200): void
{
    http_response_code($status);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode(['data' => $data, 'error' => null], JSON_UNESCAPED_UNICODE);
    exit;
}

function json_error(string $code, string $message, int $status = 400): void
{
    http_response_code($status);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode(['data' => null, 'error' => ['code' => $code, 'message' => $message]], JSON_UNESCAPED_UNICODE);
    exit;
}

function json_body(): array
{
    $raw = file_get_contents('php://input');
    $decoded = json_decode($raw, true);
    return is_array($decoded) ? $decoded : [];
}

function require_method(string $method): void
{
    if ($_SERVER['REQUEST_METHOD'] !== $method) {
        json_error('METHOD_NOT_ALLOWED', "{$method}のみ対応しています", 405);
    }
}
