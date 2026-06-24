#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)/lib/common.sh"
main() {
  local workspace="$HOME/MTAW-Workspace"
  local directory
  for directory in cases evidence-register collection-logs notebooks; do
    if [[ -d "$workspace/$directory" ]]; then report PASS "workspace structure exists: $directory"; else run_command mkdir -p "$workspace/$directory"; report PASS "workspace structure created: $directory"; fi
  done
  report 'NOT APPLICABLE' "workspace contains no case content or evidence-disk configuration"
}
main "$@"
