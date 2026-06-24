#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)/lib/common.sh"
manifest="$MTAW_STAGE_ROOT/manifests/apt-packages.txt"; require_command sudo; network_required; mapfile -t packages < <(grep -Ev '^[[:space:]]*(#|$)' "$manifest"); run sudo DEBIAN_FRONTEND=noninteractive apt-get install --yes "${packages[@]}"; report PASS "conservative core packages processed"
