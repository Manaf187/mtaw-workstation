#!/usr/bin/env bash
set -Eeuo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"
stage_name=""; from_stage=""; assume_yes=0; allow_unsupported=0

usage() { cat <<'EOF'
Usage: install.sh [--dry-run] [--yes] [--stage NAME] [--from-stage NAME] [--report-dir PATH] [--allow-unsupported-platform]

Installs the MTAW guest development baseline. Type INSTALL before changes, or
use --yes for explicit noninteractive operation. --dry-run never modifies the system.
EOF
}
while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h) usage; exit 0;; --dry-run) MTAW_DRY_RUN=1;; --yes) assume_yes=1;;
    --allow-unsupported-platform) allow_unsupported=1;; --stage) stage_name="${2:?missing stage}"; shift;;
    --from-stage) from_stage="${2:?missing stage}"; shift;; --report-dir) MTAW_REPORT_DIR="${2:?missing report directory}"; shift;;
    *) printf 'ERROR: unknown option: %s\n' "$1" >&2; usage >&2; exit 2;;
  esac; shift
done
MTAW_LOG_FILE="$MTAW_REPORT_DIR/install.log"; MTAW_REPORT_FILE="$MTAW_REPORT_DIR/report.txt"
init_reports
report PASS "options dry_run=$MTAW_DRY_RUN stage=${stage_name:-all} from_stage=${from_stage:-none} allow_unsupported=$allow_unsupported"
report PASS "block inventory before execution"; inventory

start=0; end=$((${#MTAW_STAGES[@]} - 1))
if [[ -n "$stage_name" ]]; then for i in "${!MTAW_STAGES[@]}"; do [[ "${MTAW_STAGES[$i]}" == "$stage_name" ]] && end=$i && break; done; [[ "${MTAW_STAGES[$end]}" == "$stage_name" ]] || { die "unknown stage: $stage_name"; exit 2; }; fi
if [[ -n "$from_stage" ]]; then for i in "${!MTAW_STAGES[@]}"; do [[ "${MTAW_STAGES[$i]}" == "$from_stage" ]] && start=$i && break; done; [[ "${MTAW_STAGES[$start]}" == "$from_stage" ]] || { die "unknown from-stage: $from_stage"; exit 2; }; fi
if (( start > end )); then die "requested stage range is unsafe"; exit 2; fi
if (( end > 0 && MTAW_DRY_RUN == 0 )); then
  if (( assume_yes == 0 )); then read -r -p 'Type INSTALL to continue: ' confirmation; [[ "$confirmation" == INSTALL ]] || { die "installation not confirmed"; exit 1; }; fi
  require_command sudo
fi
for ((i=start; i<=end; i++)); do
  stage="${MTAW_STAGES[$i]}"
  MTAW_CURRENT_STAGE="$stage"
  report PASS "selected stage: $stage"
  if [[ "$stage" != 00-preflight ]]; then
    validate_dependencies "$stage"
  fi
  MTAW_ALLOW_UNSUPPORTED="$allow_unsupported" MTAW_CURRENT_STAGE="$stage" MTAW_DRY_RUN="$MTAW_DRY_RUN" MTAW_REPORT_DIR="$MTAW_REPORT_DIR" MTAW_STAGE_ROOT="$root" bash "$root/guest/install/stages/$stage.sh"
  record_stage_success "$stage"
  report PASS "completed stage: $stage"
done
report 'NOT APPLICABLE' "automatic reboot is disabled"; report PASS "block inventory after execution"; inventory; report PASS "run ended"
