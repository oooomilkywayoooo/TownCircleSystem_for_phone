#!/bin/bash
# このプロジェクト専用のローカルMySQLを起動する（初回はデータディレクトリも作成する）。
# 既存のHomebrew版MySQL（rootパスワード設定済み）とは別インスタンスで、ポート3307を使う。
# root/パスワードなしのローカル開発専用インスタンス。本番用途では絶対に使わないこと。
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$DIR/local/data"
SOCKET="$DIR/local/mysql.sock"
PID_FILE="$DIR/local/mysql.pid"
LOG_FILE="$DIR/local/mysqld.log"
PORT=3307

if [ -S "$SOCKET" ] && mysqladmin --socket="$SOCKET" -uroot ping >/dev/null 2>&1; then
  echo "既に起動しています（socket: $SOCKET, port: $PORT）"
  exit 0
fi

if [ ! -d "$DATA_DIR" ]; then
  echo "初回起動: データディレクトリを作成します..."
  mkdir -p "$DATA_DIR"
  mysqld --initialize-insecure --datadir="$DATA_DIR" --basedir="$(brew --prefix mysql)"
fi

mysqld \
  --datadir="$DATA_DIR" \
  --socket="$SOCKET" \
  --port="$PORT" \
  --pid-file="$PID_FILE" \
  --mysqlx=OFF \
  > "$LOG_FILE" 2>&1 &
disown

echo "起動中です..."
for i in $(seq 1 20); do
  if [ -S "$SOCKET" ] && mysqladmin --socket="$SOCKET" -uroot ping >/dev/null 2>&1; then
    echo "起動しました（socket: $SOCKET, port: $PORT）"

    # 初回のみスキーマを流し込む
    if ! mysql --socket="$SOCKET" -uroot -e "USE towncircle;" >/dev/null 2>&1; then
      echo "初回起動: towncircleデータベースを作成し、スキーマを適用します..."
      mysql --socket="$SOCKET" -uroot -e "CREATE DATABASE towncircle CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
      mysql --socket="$SOCKET" -uroot towncircle < "$DIR/schema.sql"
      if [ -f "$DIR/seed.sql" ]; then
        mysql --socket="$SOCKET" -uroot --default-character-set=utf8mb4 towncircle < "$DIR/seed.sql"
      fi
      echo "スキーマ適用が完了しました。"
    fi
    exit 0
  fi
  sleep 0.5
done

echo "起動確認がタイムアウトしました。$LOG_FILE を確認してください。" >&2
exit 1
