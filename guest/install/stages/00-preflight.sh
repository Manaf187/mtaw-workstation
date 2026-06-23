#!/usr/bin/env bash
set -Eeuo pipefail

readonly SCRIPT_NAME="$(basename "$0")"

timestamp() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

log() {
  printf '%s %s: %s\n' "$(timestamp)" "$SCRIPT_NAME" "$*"
}

error_handler() {
  local exit_code="$1"
  local line_number="$2"
  printf '%s %s: ERROR at line %s (exit %s)\n' \
    "$(timestamp)" "$SCRIPT_NAME" "$line_number" "$exit_code" >&2
}

trap 'error_handler "$?" "$LINENO"' ERR

usage() {
  cat <<'EOF'
Usage: 00-preflight.sh [--help]

Inspect the current environment for the MTAW bootstrap framework. This stage is
read-only and does not configure VirtualBox, install packages, or modify Ubuntu.
EOF
}

require_command() {
  local command_name="$1"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf '%s %s: ERROR required command not found: %s\n' \
      "$(timestamp)" "$SCRIPT_NAME" "$command_name" >&2
    return 1
  fi
}

main() {
  case "${1:-}" in
    "")
      ;;
    --help|-h)
      usage
      return 0
      ;;
    *)
      usage >&2
      return 2
      ;;
  esac

  require_command date
  require_command uname
  log "preflight is read-only"
  log "root privileges are not required for this bootstrap preflight"
  log "detected platform: $(uname -s) $(uname -r)"
  log "result: NOT VALIDATED — no guest configuration is implemented"
}

main "$@"
