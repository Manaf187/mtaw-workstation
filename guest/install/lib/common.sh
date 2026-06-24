#!/usr/bin/env bash
set -Eeuo pipefail

MTAW_STAGES=(00-preflight 10-system-baseline 20-core-packages 30-python-environment 40-browsers 50-workspace-templates 60-security-defaults 70-validation)
MTAW_DRY_RUN="${MTAW_DRY_RUN:-0}"
MTAW_REPORT_DIR="${MTAW_REPORT_DIR:-$HOME/.local/state/mtaw}"
MTAW_LOG_FILE="${MTAW_LOG_FILE:-$MTAW_REPORT_DIR/install.log}"
MTAW_REPORT_FILE="${MTAW_REPORT_FILE:-$MTAW_REPORT_DIR/report.txt}"

utc() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
log() { printf '%s %s\n' "$(utc)" "$*" | tee -a "$MTAW_LOG_FILE"; }
report() { printf '%s %s %s\n' "$1" "$(utc)" "$2" | tee -a "$MTAW_REPORT_FILE"; }
die() { report FAIL "$1"; return 1; }
require_command() { command -v "$1" >/dev/null 2>&1 || die "required command unavailable: $1"; }
run() { if [[ "$MTAW_DRY_RUN" == 1 ]]; then log "DRY RUN: $*"; else "$@"; fi; }
network_required() { getent hosts archive.ubuntu.com >/dev/null 2>&1 || die "network resolution is required for this stage"; }
init_reports() { mkdir -p "$MTAW_REPORT_DIR"; : >"$MTAW_LOG_FILE"; : >"$MTAW_REPORT_FILE"; report PASS "run started"; }
inventory() { lsblk --output NAME,TYPE,SIZE,FSTYPE,MOUNTPOINTS 2>&1 | tee -a "$MTAW_REPORT_FILE"; }
os_release_file() { printf '%s' "${MTAW_OS_RELEASE_FILE:-/etc/os-release}"; }
machine_arch() { printf '%s' "${MTAW_ARCH:-$(uname -m)}"; }
is_reference_release() { [[ "${VERSION_ID:-}" == "24.04" && "${UBUNTU_CODENAME:-}" == "noble" ]]; }
