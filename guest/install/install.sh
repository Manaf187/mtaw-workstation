#!/usr/bin/env bash
set -Eeuo pipefail

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

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
Usage: install.sh [--help]

Run the MTAW bootstrap preflight framework. This command performs read-only
checks only; it does not install packages or configure an MTAW workstation.
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

  require_command bash
  require_command date
  log "running read-only preflight; no workstation changes will be made"
  "${SCRIPT_DIR}/stages/00-preflight.sh"
}

main "$@"
