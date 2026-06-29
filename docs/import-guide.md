# MTAW v0.1.0-rc1 OVA Import Guide

This guide covers manual VirtualBox import review for the controlled
v0.1.0-rc1 release candidate. Acceptance status is author-reported PASS on
VirtualBox `7.1.10r169112`. The project reference baseline remains VirtualBox
`7.2`, and VirtualBox `7.2` compatibility testing is PENDING. This guide does
not claim automated CI validation, third-party certification, production
certification, or independently witnessed testing.

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

- OVA checksum verified: author-reported PASS
- OVA import completed: author-reported PASS
- Imported appliance boot: author-reported PASS
- Release-candidate functional acceptance: author-reported PASS
- Isolation settings confirmed: author-reported PASS
- Guest boot verified: author-reported PASS
- MTAW shell verified: author-reported PASS
- Jupyter loopback verified: author-reported PASS
- Core tools verified: author-reported PASS
- Evidence disk state verified: author-reported PASS
- Acceptance decision: controlled RC1 acceptance author-reported PASS
