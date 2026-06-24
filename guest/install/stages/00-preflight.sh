#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)/lib/common.sh"
source "$(os_release_file)"
arch="$(machine_arch)"; report PASS "platform id=${ID:-unknown} version=${VERSION_ID:-unknown} arch=$arch"
if [[ "${ID:-}" != ubuntu || "${VERSION_ID:-}" != 24.04 || ! "$arch" =~ ^(x86_64|amd64)$ ]]; then
  if [[ "${MTAW_ALLOW_UNSUPPORTED:-0}" == 1 ]]; then report WARN "unsupported platform override supplied; no validation claim"; else die "unsupported platform; use --allow-unsupported-platform only for development testing"; exit 1; fi
fi
[[ "${VERSION_ID:-}" == 24.04 ]] && report PASS "Ubuntu 24.04.x accepted for development testing"
[[ "${VERSION:-}" == *"24.04.4"* ]] || report WARN "reference baseline is Ubuntu 24.04.4; detected point release is not validated"
for c in bash sudo apt systemctl git getent lsblk; do require_command "$c"; done
[[ -d /run/live/medium ]] && { die "live environment detected"; exit 1; } || report PASS "installed-system indicator present"
report PASS "memory=$(awk '/MemTotal/{print $2" kB"}' /proc/meminfo) cpu=$(nproc) timezone=$(timedatectl show -p Timezone --value 2>/dev/null || printf unknown)"; report PASS "disk inventory follows"; inventory
