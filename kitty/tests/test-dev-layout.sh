#!/bin/bash
set -euo pipefail

repo_dir=$(cd "$(dirname "$0")/.." && pwd)
fake_bin=$(mktemp -d)
calls_file=$(mktemp)
trap 'rm -rf "$fake_bin"; rm -f "$calls_file"' EXIT

cat > "$fake_bin/kitty" <<'FAKE_KITTY'
#!/bin/bash
printf '%s\n' "$*" >> "$KITTY_CALLS"
if [[ "$*" == *"--location=vsplit"* ]]; then
  printf '41\n'
fi
FAKE_KITTY
chmod +x "$fake_bin/kitty"

KITTY_CALLS="$calls_file" PATH="$fake_bin:$PATH" \
  "$repo_dir/sessions/dev-layout.sh" >/dev/null

right_bottom_call=$(sed -n '3p' "$calls_file")
[[ "$right_bottom_call" == *"--source-window id:41"* ]]
[[ "$right_bottom_call" == *"--next-to id:41"* ]]
