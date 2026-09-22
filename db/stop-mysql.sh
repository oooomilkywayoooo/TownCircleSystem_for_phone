#!/bin/bash
# start-mysql.sh で起動したローカルMySQLを停止する。
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOCKET="$DIR/local/mysql.sock"

if [ -S "$SOCKET" ]; then
  mysqladmin --socket="$SOCKET" -uroot shutdown
  echo "停止しました"
else
  echo "起動していません"
fi
