#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)/lib/common.sh"
workspace="$HOME/MTAW-Workspace"; run mkdir -p "$workspace"/{cases,evidence-register,collection-logs,notebooks}; report PASS "sanitized workspace structure processed at $workspace; use UTC and ISO 8601-compatible names"
