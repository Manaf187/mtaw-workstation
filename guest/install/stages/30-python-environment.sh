#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)/lib/common.sh"
venv="$HOME/.local/share/mtaw/venv"; requirements="$MTAW_STAGE_ROOT/manifests/python-requirements.in"; require_command python3.12; network_required; run mkdir -p "$(dirname "$venv")" "$HOME/.local/bin"; [[ -x "$venv/bin/python" ]] || run python3.12 -m venv "$venv"; run "$venv/bin/python" -m pip install --upgrade pip; run "$venv/bin/python" -m pip install -r "$requirements"; run install -m 0755 "$MTAW_STAGE_ROOT/guest/bin/mtaw-activate" "$HOME/.local/bin/mtaw-activate"; run install -m 0755 "$MTAW_STAGE_ROOT/guest/bin/mtaw-jupyter" "$HOME/.local/bin/mtaw-jupyter"; report PASS "per-user Python environment processed at $venv"
