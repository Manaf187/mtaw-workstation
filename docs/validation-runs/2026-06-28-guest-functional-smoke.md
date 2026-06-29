# 2026-06-28 Guest Functional Smoke Test

## Scope

This note records a reported guest-side functional smoke test after the clean
Ubuntu Desktop 24.04.4 LTS amd64 installer run. It covers a small set of
analyst-environment checks only.

This is not host-control validation, full workstation functional validation,
appliance validation, OVA validation, release evidence, checksum evidence, or
operational suitability evidence.

## Reported Checks

- `mtaw-shell` activated the MTAW Python virtual environment.
- `VIRTUAL_ENV` resolved to `/home/mtaw-builder/.local/share/mtaw/venv`.
- `python` resolved to the MTAW virtual environment interpreter.
- Python reported version `3.12.3`.
- Python imports succeeded for:
  - `pandas`
  - `requests`
  - `bs4`
  - `openpyxl`
  - `matplotlib`
  - `networkx`
- `mtaw-jupyter` started JupyterLab from the MTAW virtual environment.
- Jupyter served on `127.0.0.1:8888`.
- Token authentication was enabled.

## Notes

Jupyter reported that it could not determine JupyterLab build status without
Node.js. This was treated as non-blocking for the smoke test because JupyterLab
started and served on loopback with token authentication.

## Remaining Validation Gaps

- Host and VirtualBox controls remain unvalidated.
- Evidence-disk setup and encryption remain planned.
- Backup configuration remains planned.
- Appliance sanitization, OVA export, signing, checksum publication, and
  re-import testing were not performed as part of this smoke test. RC1 OVA
  re-import acceptance was later recorded as author-reported PASS.
- Operational analyst suitability testing has not been performed.
