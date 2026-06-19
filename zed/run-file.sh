#!/usr/bin/env zsh
# Zed: 按文件后缀运行当前文件。$1 = 文件绝对路径 (来自 $ZED_FILE)
f="$1"
case "$f" in
  *.py)              python3 "$f" ;;
  *.js|*.mjs|*.cjs)  node "$f" ;;
  *.ts)              bun "$f" 2>/dev/null || npx tsx "$f" ;;
  *.sh)              bash "$f" ;;
  *.rb)              ruby "$f" ;;
  *.lua)             lua "$f" ;;
  *.go)              go run "$f" ;;
  *.rs)              cargo run 2>/dev/null || { rustc "$f" -o /tmp/zedrun && /tmp/zedrun; } ;;
  *.c)               cc "$f" -o /tmp/zedrun && /tmp/zedrun ;;
  *.cpp|*.cc|*.cxx)  c++ -std=c++20 "$f" -o /tmp/zedrun && /tmp/zedrun ;;
  *.c3)              c3c compile-run "$f" ;;
  *.java)            java "$f" ;;
  *)                 echo "No runner for ${f##*/}" ;;
esac
