# MTAW v0.1.0-rc1 Release Validation Record

## Release Identity

- Product: Modern Threat Analyst Workstation
- Release status: Release Candidate 1
- Version: `0.1.0-rc1`
- Repository commit:
  `fea24326bbae5d7904bddcb66b7fc4a64382d0b2`
- Platform baseline: Ubuntu Desktop 24.04.4 LTS amd64

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
- SHA-256:
  `cfc52f7266c28ccf361bb78abc3978bb27601811e5abe84c4da8b1737747f08a`
- OVA export: completed
- SHA-256 generation: completed
- SHA-256 verification: completed successfully

## Completed Checks

- One-command setup workflow completed.
- Real Ubuntu 24.04.4 installation completed.
- Stage 70 validation completed successfully.
- Appliance sanitization completed.
- OVA export completed.
- SHA-256 generated and verified.

## Pending Checks

- Independent OVA re-import acceptance: PENDING
- First-boot credential provisioning: PENDING
- Public release approval: PENDING
- Operational suitability certification: PENDING
- Host-control validation: PENDING
- Evidence-disk encryption: PENDING
- Backup configuration: PENDING
- Code signing: PENDING
- Release signing: PENDING
- Long-term compatibility testing: PENDING

## Known Limitations

- This is an internal or controlled release candidate, not a final public
  appliance.
- No public OVA download URL is recorded.
- No GitHub release URL is recorded.
- No release tag is recorded.
- No signing result is recorded.
- No independent OVA re-import result is recorded.
- No first-boot credential behavior is claimed.

## Release Decision

MTAW v0.1.0-rc1 is a controlled release candidate pending independent OVA
re-import acceptance and first-boot credential provisioning. It is not approved
as a final public appliance release.
