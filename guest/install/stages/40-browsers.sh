#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)/lib/common.sh"
require_command sudo; network_required; command -v firefox >/dev/null 2>&1 && report PASS "Firefox already available" || { run sudo DEBIAN_FRONTEND=noninteractive apt-get install --yes firefox; report PASS "Firefox installation requested"; }; if command -v chromium >/dev/null 2>&1 || command -v chromium-browser >/dev/null 2>&1; then report PASS "Chromium already available"; else run sudo DEBIAN_FRONTEND=noninteractive apt-get install --yes chromium-browser; report PASS "Chromium installation requested"; fi
