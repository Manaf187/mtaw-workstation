# MTAW v0.1.0-rc1 Release Validation Record

## Release Identity

- Product: Modern Threat Analyst Workstation
- Release status: Release Candidate 1
- Version: `0.1.0-rc1`
- Repository commit:
  `fea24326bbae5d7904bddcb66b7fc4a64382d0b2`
- Platform baseline: Ubuntu Desktop 24.04.4 LTS amd64
- Project reference hypervisor baseline: Oracle VirtualBox `7.2`
- RC1 build and author-reported re-import host: Oracle VirtualBox
  `7.1.10r169112`
- VirtualBox `7.2` compatibility testing: PENDING

## Installer And Validation

- Installer exit status: `0`
- Stage 70 validation: completed successfully
- Required installer stages: passed
- Mandatory validation failures: none observed
- Mandatory validation warnings: none observed
- Block-device inventory: unchanged during installer execution
- Evidence disk: left unpartitioned, without a filesystem, and unmounted
- Scoped MTAW credential check: passed
- Guest Additions observed in the built VM: `7.1.10r169112`

## OVA Artifact

- OVA filename: `MTAW-Workstation-v0.1.0-Ubuntu24.04-amd64.ova`
- OVA size: `10,006,708,736` bytes
- Observed OVA last-write timestamp: `2026-06-29T16:57:07Z`
- SHA-256:
  `cfc52f7266c28ccf361bb78abc3978bb27601811e5abe84c4da8b1737747f08a`
- OVA export: completed
- SHA-256 generation: completed
- SHA-256 verification: completed successfully
- OVA re-import acceptance: author-reported PASS
- Imported appliance boot: author-reported PASS
- Release-candidate functional acceptance: author-reported PASS

The artifact filename was retained exactly as exported and checksum-verified:
`MTAW-Workstation-v0.1.0-Ubuntu24.04-amd64.ova`. The release status is
controlled RC1; the filename itself does not establish final-release status.

## Completed Checks

- One-command setup workflow completed.
- Real Ubuntu 24.04.4 installation completed.
- Stage 70 validation completed successfully.
- Appliance sanitization completed.
- OVA export completed.
- SHA-256 generated and verified.

## Pending Checks

- First-boot credential provisioning: PENDING
- Public release approval: PENDING
- Operational suitability certification: PENDING
- Host-control validation: PENDING
- Evidence-disk encryption: PENDING
- Backup configuration: PENDING
- Code signing: PENDING
- Release signing: PENDING
- Long-term compatibility testing: PENDING
- VirtualBox `7.2` compatibility testing: PENDING

## Known Limitations

- This is an internal or controlled release candidate, not a final public
  appliance.
- No public OVA download URL is recorded.
- No GitHub release URL is recorded.
- No release tag is recorded.
- No signing result is recorded.
- OVA re-import acceptance is author-reported PASS and is not automated CI
  validation, third-party certification, production certification, or
  independently witnessed testing.
- No first-boot credential behavior is claimed.

## Release Decision

Installer validation passed, sanitization completed, OVA export and SHA-256
verification completed, and author-reported OVA re-import acceptance passed.
MTAW v0.1.0-rc1 remains a controlled release candidate. Public OVA
distribution remains blocked by first-boot credential provisioning and release
approval. It is not approved as a final public appliance release.
