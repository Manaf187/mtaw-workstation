# Changelog

## 0.1.0-rc1 - Controlled release candidate

- Prepared Modern Threat Analyst Workstation v0.1.0 Release Candidate 1 from
  repository commit `fea24326bbae5d7904bddcb66b7fc4a64382d0b2`.
- Recorded the Ubuntu Desktop 24.04.4 LTS amd64 appliance export as
  `MTAW-Workstation-v0.1.0-Ubuntu24.04-amd64.ova`.
- Recorded OVA size `10,006,708,736` bytes and SHA-256 digest
  `cfc52f7266c28ccf361bb78abc3978bb27601811e5abe84c4da8b1737747f08a`.
- Recorded installer exit status `0`, successful Stage 70 validation, required
  installer stages passed, unchanged block-device inventory, and scoped MTAW
  credential check passed.
- Recorded evidence disk state as unpartitioned, without a filesystem, and
  unmounted.
- Recorded Guest Additions version `7.1.10r169112`.
- Recorded VirtualBox host version used for the RC1 build and author-reported
  re-import acceptance as `7.1.10r169112`; VirtualBox `7.2` compatibility
  testing remains pending.
- Recorded observed OVA last-write timestamp
  `2026-06-29T16:57:07Z`.
- Recorded OVA export, SHA-256 generation, and SHA-256 verification as
  completed.
- Recorded OVA re-import acceptance, imported appliance boot, and
  release-candidate functional acceptance as author-reported PASS.
- This is a controlled release candidate. First-boot credential provisioning,
  public release approval, signing, host-control validation, and operational
  suitability remain pending.

## 0.1.0-dev — Unvalidated development baseline

- Established the repository-first MTAW foundation.
- Added the locked baseline manifest, policy documentation, safe script
  framework, and repository checks.
- Added an unvalidated staged Ubuntu guest installer and repository-only
  regression coverage. No guest, VM, host, appliance, or OVA validation result
  is represented by this change.

No workstation, appliance, release, or validation result is represented by
this version.
