#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)/lib/common.sh"
main() {
  local venv="$HOME/.local/share/mtaw/venv"
  require_command python3.12
  network_required
  run_command mkdir -p "$(dirname "$venv")" "$HOME/.local/bin"
  [[ -x "$venv/bin/python" ]] || run_command python3.12 -m venv "$venv"
  run_command "$venv/bin/python" -m pip install --upgrade pip
  run_command "$venv/bin/python" -m pip install -r "$MTAW_STAGE_ROOT/manifests/python-requirements.in"
  run_command install -m 0755 "$MTAW_STAGE_ROOT/guest/bin/mtaw-shell" "$HOME/.local/bin/mtaw-shell"
  run_command install -m 0755 "$MTAW_STAGE_ROOT/guest/bin/mtaw-jupyter" "$HOME/.local/bin/mtaw-jupyter"
  report PASS "per-user Python environment processed"
}
main "$@"
