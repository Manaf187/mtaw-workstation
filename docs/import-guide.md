# MTAW v0.1.0-rc1 OVA Import Guide

This guide covers manual VirtualBox import review for the controlled
v0.1.0-rc1 release candidate. Acceptance status is `PENDING`; this guide does
not claim that independent OVA re-import testing has passed.

## Verify Checksum Before Import

Expected OVA:

```text
MTAW-Workstation-v0.1.0-Ubuntu24.04-amd64.ova
```

Expected SHA-256:

```text
cfc52f7266c28ccf361bb78abc3978bb27601811e5abe84c4da8b1737747f08a
```

Verify the downloaded file before import. Do not import an OVA whose digest
does not match the release checksum record.

## Import Settings

1. Import the OVA under a new VM name.
2. Use NAT-only networking.
3. Disable shared clipboard.
4. Disable drag-and-drop.
5. Confirm no shared folders are configured.
6. Confirm USB passthrough is disabled or has no filters by default.
7. Do not use bridged networking unless specifically approved.

## Boot Verification

After first boot, verify the guest starts successfully and remains isolated by
the settings above. Record the VM name, import operator, import date, and any
settings changed during import.

## Guest Tool Checks

Run these inside the VM:

```bash
mtaw-shell
echo "$VIRTUAL_ENV"
which python
python --version
python - <<'PY'
import pandas, requests, bs4, openpyxl, matplotlib, networkx
print("python toolchain ok")
PY
exit
```

Start Jupyter and confirm it binds to loopback with token authentication:

```bash
mtaw-jupyter
```

Stop it with `Ctrl+C` after confirming startup.

Check core tools:

```bash
python3.12 --version
~/.local/share/mtaw/venv/bin/python -m jupyterlab --version
ffmpeg -version | head -n 1
exiftool -ver
trans -V
```

## Evidence Disk Inspection

Inspect block devices and confirm the evidence disk remains unpartitioned,
without a filesystem, and unmounted until configured under organizational
policy:

```bash
lsblk --output NAME,TYPE,SIZE,FSTYPE,MOUNTPOINTS
```

## Acceptance Record

- OVA checksum verified: PENDING
- OVA import completed: PENDING
- Isolation settings confirmed: PENDING
- Guest boot verified: PENDING
- MTAW shell verified: PENDING
- Jupyter loopback verified: PENDING
- Core tools verified: PENDING
- Evidence disk state verified: PENDING
- Acceptance decision: PENDING
