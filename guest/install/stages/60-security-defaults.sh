#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)/lib/common.sh"
main() {
  report 'NOT TESTED' "firewall privileged observation is not performed by installer"
  report 'NOT APPLICABLE' "SSH, integrations, backups, and evidence-disk configuration excluded"
}
main "$@"
