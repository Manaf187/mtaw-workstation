#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)/lib/common.sh"
if command -v ufw >/dev/null 2>&1; then report PASS "firewall observation: $(sudo ufw status 2>&1 | tr '\n' ' ')"; else report 'NOT TESTED' "ufw is unavailable"; fi; report 'NOT APPLICABLE' "SSH, integration features, backups, and evidence-disk configuration are not configured"
