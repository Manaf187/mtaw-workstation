#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)/lib/common.sh"
failures=0
check() {
  local description="$1"
  shift

  if "$@"; then
    report PASS "$description"
  else
    report FAIL "$description"
    failures=$((failures + 1))
  fi
}
validate_architecture() {
  local detected_arch
  detected_arch="$(machine_arch)"
  case "$detected_arch" in
    x86_64|amd64) report PASS "supported architecture observed: ${detected_arch}" ;;
    *) report FAIL "unsupported architecture observed: ${detected_arch}"; failures=$((failures + 1)) ;;
  esac
}
main() {
  source "$(os_release_file)"
  check "Ubuntu family" test "${ID:-}" = ubuntu
  report PASS "detected release: ${VERSION:-unknown}"
  if is_reference_release; then report PASS "Ubuntu 24.04.4 reference baseline"; else report WARN "permitted development-test candidate; compatibility and validation not established"; fi
  validate_architecture
  check "Python 3.12" command -v python3.12
  check "virtual environment" test -x "$HOME/.local/share/mtaw/venv/bin/python"
  check "mtaw-shell launcher" test -x "$HOME/.local/bin/mtaw-shell"
  check "mtaw-jupyter launcher" test -x "$HOME/.local/bin/mtaw-jupyter"
  for command in git curl wget jq rg file exiftool sqlite3 tmux tree; do check "command: $command" command -v "$command"; done
  if [[ -f "$MTAW_REPORT_DIR/lsblk-before.txt" ]]; then
    report PASS "block inventory before execution present"
  else
    report WARN "block inventory before execution unavailable"
  fi
  report 'NOT TESTED' "clean-VM reproducibility, host controls, and appliance validation are outside this observed guest run"
  report 'NOT APPLICABLE' "evidence-disk, SSH, backups, host integration, OVA, signing, publishing excluded"
  (( failures == 0 ))
}
main "$@"
