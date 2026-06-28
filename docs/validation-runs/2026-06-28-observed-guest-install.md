# 2026-06-28 Observed Guest Install

## Scope

This note records one observed MTAW guest installer run reported from an Ubuntu
Desktop 24.04.4 LTS amd64 development VM. It is repository documentation of an
observed guest-side run only.

This is not clean-VM reproducibility evidence, host-control validation,
workstation functional validation, appliance validation, OVA validation,
release evidence, checksum evidence, or operational suitability evidence.

## Environment

- Guest OS: Ubuntu Desktop 24.04.4 LTS amd64.
- Installer version: `0.1.0-dev`.
- Repository branch: `main`.
- Evidence location retained outside the repository:
  `~/mtaw-validation-evidence`.

## Run Summary

- The installer initially progressed through `30-python-environment`.
- A Chromium Snap transition path was deferred by repository fix
  `1ec42a1 fix: defer Chromium snap transition install`.
- The installer was resumed from `40-browsers`.
- Stage `70-validation` completed with exit code `0`.

Observed final report outcomes included:

- Stage states `00-preflight` through `60-security-defaults`: `PASS`.
- `70-validation`: completed with exit code `0`.
- Block inventory before execution: `PASS`.
- Block inventory after execution: `PASS`.
- Block inventory comparison: `PASS` unchanged.
- Scoped MTAW credential check: `PASS`.
- Automatic reboot: `NOT APPLICABLE`.
- Evidence disk, SSH, backups, host integration, OVA, signing, and publishing:
  `NOT APPLICABLE`.
- Clean-VM reproducibility, host controls, and appliance validation:
  `NOT TESTED`.

## Follow-Up

The next validation milestone is a clean-VM reproducibility run from a fresh
snapshot or newly created VM, using the current `main` branch without manual
mid-run recovery.
