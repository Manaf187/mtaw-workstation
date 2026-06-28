#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)/lib/common.sh"
main() {
  network_required
  if command -v firefox >/dev/null 2>&1; then report PASS "Firefox already present"; else run_privileged env DEBIAN_FRONTEND=noninteractive apt-get install --yes firefox; report PASS "Firefox installation requested"; fi
  if command -v chromium >/dev/null 2>&1 || command -v chromium-browser >/dev/null 2>&1; then
    report PASS "Chromium already present"
  else
    report WARN "Chromium compatibility browser unavailable; Ubuntu chromium-browser uses a Snap transition package and is deferred for manual review"
  fi
}
main "$@"
