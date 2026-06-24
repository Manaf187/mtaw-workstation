#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)/lib/common.sh"
main() {
  local manifest="$MTAW_STAGE_ROOT/manifests/apt-packages.txt"
  local packages=()
  network_required
  mapfile -t packages < <(grep -Ev '^[[:space:]]*(#|$)' "$manifest")
  run_privileged env DEBIAN_FRONTEND=noninteractive apt-get install --yes "${packages[@]}"
  report PASS "core package installation processed"
}
main "$@"
