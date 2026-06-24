#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)/lib/common.sh"
main() {
  network_required
  run_privileged timedatectl set-timezone UTC
  run_privileged env DEBIAN_FRONTEND=noninteractive apt-get update
  run_privileged env DEBIAN_FRONTEND=noninteractive apt-get --yes upgrade
  report PASS "system baseline applied; reboot not automatic"
}
main "$@"
