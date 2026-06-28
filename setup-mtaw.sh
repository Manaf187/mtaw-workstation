#!/usr/bin/env bash
set -Eeuo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
installer="$repo_root/guest/install/install.sh"

usage() {
  cat <<'EOF'
Usage: setup-mtaw.sh [--dry-run] [--report-dir PATH] [installer options]

Configure the MTAW Ubuntu guest workstation using the existing staged
installer at guest/install/install.sh.

Common commands:
  bash setup-mtaw.sh --dry-run
  bash setup-mtaw.sh

This wrapper contains no installation logic. It locates the repository root
and forwards arguments to the staged installer.
EOF
}

case "${1:-}" in
  --help|-h)
    usage
    exit 0
    ;;
esac

exec bash "$installer" "$@"
