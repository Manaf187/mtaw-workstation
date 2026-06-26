#!/usr/bin/env bash
set -Eeuo pipefail

MTAW_DRY_RUN="${MTAW_DRY_RUN:-0}"
MTAW_REPORT_DIR="${MTAW_REPORT_DIR:-$HOME/.local/state/mtaw}"
MTAW_LOG_FILE="$MTAW_REPORT_DIR/install.log"
MTAW_REPORT_FILE="$MTAW_REPORT_DIR/report.txt"
MTAW_STATE_DIR="$MTAW_REPORT_DIR/stages"
MTAW_CURRENT_STAGE="${MTAW_CURRENT_STAGE:-}"
readonly MTAW_STAGES=(00-preflight 10-system-baseline 20-core-packages 30-python-environment 40-browsers 45-osint-core 50-workspace-templates 60-security-defaults 70-validation)
utc() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
die() { printf '%s ERROR: %s\n' "$(utc)" "$*" >&2; }
log() { if [[ "$MTAW_DRY_RUN" == 1 ]]; then printf '%s %s\n' "$(utc)" "$*"; else printf '%s %s\n' "$(utc)" "$*" | tee -a "$MTAW_LOG_FILE"; fi; }
report() { if [[ "$MTAW_DRY_RUN" == 1 ]]; then printf '%s %s %s\n' "$1" "$(utc)" "$2"; else printf '%s %s %s\n' "$1" "$(utc)" "$2" | tee -a "$MTAW_REPORT_FILE"; fi; }
require_command() { command -v "$1" >/dev/null 2>&1 || { report FAIL "missing command: $1"; return 1; }; }
init_reports() { [[ "$MTAW_DRY_RUN" == 1 ]] && return; mkdir -p "$MTAW_REPORT_DIR" "$MTAW_STATE_DIR"; : >"$MTAW_LOG_FILE"; : >"$MTAW_REPORT_FILE"; inventory before; }
inventory() { [[ "$MTAW_DRY_RUN" == 1 ]] && return; lsblk --output NAME,TYPE,SIZE,FSTYPE,MOUNTPOINTS >"$MTAW_REPORT_DIR/lsblk-$1.txt" 2>&1; }
compare_inventories() { [[ "$MTAW_DRY_RUN" == 1 ]] && return; if ! diff -u "$MTAW_REPORT_DIR/lsblk-before.txt" "$MTAW_REPORT_DIR/lsblk-after.txt" >/dev/null; then report WARN "block inventory changed; this does not prove forensic integrity"; fi; }
finalize_run() { local code="$?"; [[ "$MTAW_DRY_RUN" == 1 ]] && return; inventory after; compare_inventories; report $([[ "$code" == 0 ]] && printf PASS || printf FAIL) "run ended stage=${MTAW_CURRENT_STAGE:-none} exit=$code reboot=NOT_APPLICABLE"; }
trap finalize_run EXIT
run_command() { log "COMMAND: $*"; [[ "$MTAW_DRY_RUN" == 1 ]] && { log "DRY RUN: $*"; return 0; }; "$@" >>"$MTAW_LOG_FILE" 2>&1; }
run_privileged() { [[ "$MTAW_DRY_RUN" == 1 ]] && { log "DRY RUN privileged: $*"; return 0; }; require_command sudo; run_command sudo "$@"; }
record_stage_success() { [[ "$MTAW_DRY_RUN" == 1 ]] && return; local tmp="$MTAW_STATE_DIR/$1.tmp"; printf 'version=%s\nstage=%s\ncompleted=%s\n' "$(cat "$MTAW_STAGE_ROOT/VERSION")" "$1" "$(utc)" >"$tmp"; mv "$tmp" "$MTAW_STATE_DIR/$1.state"; }
validate_dependencies() { [[ "$MTAW_DRY_RUN" == 1 || "$1" == 00-preflight || "$1" == 10-system-baseline ]] && return; [[ -f "$MTAW_STATE_DIR/10-system-baseline.state" ]] || { report FAIL "missing successful dependency: 10-system-baseline"; return 1; }; }
network_required() { getent hosts archive.ubuntu.com >/dev/null 2>&1 || { report FAIL "network resolution required"; return 1; }; }
os_release_file() { printf '%s' "${MTAW_OS_RELEASE_FILE:-/etc/os-release}"; }
machine_arch() { printf '%s' "${MTAW_ARCH:-$(uname -m)}"; }
is_reference_release() { [[ "${VERSION:-}" == *"24.04.4"* ]]; }
