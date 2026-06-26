#!/usr/bin/env bash
set -Eeuo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)/lib/common.sh"

osint_core_manifest="$MTAW_STAGE_ROOT/manifests/osint-core-tools.yaml"

usage() {
  cat <<'EOF'
Usage: 45-osint-core.sh [--help]

Install the controlled MTAW OSINT core profile. The stage uses only reviewed
APT packages from manifests/osint-core-tools.yaml and does not install
specialist tools, browser extensions, credentials, or browser profile data.
EOF
}

manifest_apt_packages() {
  awk '
    $0 ~ /^  apt_packages:/ {in_packages=1; next}
    in_packages && $0 ~ /^  [a-z_]+:/ {in_packages=0}
    in_packages && $1 == "-" {print $2}
  ' "$osint_core_manifest"
}

main() {
  local packages=()

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

  require_command awk
  [[ -f "$osint_core_manifest" ]] || { report FAIL "missing OSINT core manifest"; return 1; }
  mapfile -t packages < <(manifest_apt_packages)
  [[ "${#packages[@]}" -gt 0 ]] || { report FAIL "OSINT core manifest contains no APT packages"; return 1; }

  network_required
  run_privileged env DEBIAN_FRONTEND=noninteractive apt-get \
    -o Acquire::http::Timeout=30 \
    -o Acquire::https::Timeout=30 \
    install --yes "${packages[@]}"
  report PASS "OSINT core APT packages processed: ${packages[*]}"
  report PASS "ExifTool remains provided by the base package manifest"
  report 'NOT APPLICABLE' "specialist OSINT tools, browser extensions, credentials, and browser profiles are excluded"
}

main "$@"
