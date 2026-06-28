# 2026-06-28 Clean-VM Reproducibility Observation

## Scope

This note records a reported clean Ubuntu Desktop 24.04.4 LTS amd64 VM run of
the current `main` branch after the observed guest-install fixes were merged.
The reported result was that the dry run and full installer completed with all
installer validation checks passing.

This note does not include raw logs. The supporting evidence was retained
outside the repository under the VM user's validation-evidence directory.

This is not host-control validation, workstation functional validation,
appliance validation, OVA validation, release evidence, checksum evidence, or
operational suitability evidence.

## Environment

- Guest OS: Ubuntu Desktop 24.04.4 LTS amd64.
- Installer version: `0.1.0-dev`.
- Repository branch: `main`.
- Test type: clean-VM guest installer reproducibility observation.

## Reported Result

- `bash guest/install/install.sh --dry-run`: passed.
- `bash guest/install/install.sh --yes`: passed.
- Stage `70-validation`: passed.
- Stage states `00-preflight` through `60-security-defaults`: passed.
- Block inventory before and after execution: passed.
- Scoped MTAW credential check: passed.

## Remaining Validation Gaps

- Host controls are not validated by guest scripts.
- Workstation functional suitability is not validated.
- Appliance sanitization is not validated.
- OVA export, signing, checksum publication, and re-import testing have not
  been performed.
- The evidence disk remains planned and was not configured by this run.
