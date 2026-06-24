#!/usr/bin/env bash
set -Eeuo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)/lib/common.sh"

check_platform() {
  source "$(os_release_file)"
  local arch
  arch="$(machine_arch)"
  report PASS "platform id=${ID:-unknown} release=${VERSION:-unknown} arch=$arch"
  if [[ "${ID:-}" != ubuntu || "${VERSION_ID:-}" != 24.04 || ! "$arch" =~ ^(x86_64|amd64)$ ]]; then
    [[ "${MTAW_ALLOW_UNSUPPORTED:-0}" == 1 ]] && { report WARN "unsupported-platform override recorded; validation not established"; return; }
    report FAIL "unsupported platform; explicit override required"
    return 1
  fi
  if is_reference_release; then report PASS "Ubuntu 24.04.4 reference baseline observed"; else report WARN "permitted development-test candidate; compatibility and validation not established"; fi
}

main() {
  local command
  check_platform
  [[ -d /run/live/medium ]] && { report FAIL "live media detected"; return 1; }
  for command in bash sudo apt systemctl git getent lsblk; do require_command "$command"; done
  report PASS "memory=$(awk '/MemTotal/{print $2" kB"}' /proc/meminfo) cpu=$(nproc)"
  if getent hosts archive.ubuntu.com >/dev/null 2>&1; then report PASS "network resolution observed"; else report WARN "network resolution unavailable"; fi
  inventory preflight
}

main "$@"
