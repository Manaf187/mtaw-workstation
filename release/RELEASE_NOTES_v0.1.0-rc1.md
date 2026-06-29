# MTAW Workstation v0.1.0-rc1 Release Notes

Modern Threat Analyst Workstation v0.1.0-rc1 is a controlled release candidate
for review. It is not a final public appliance release.

External OVA download location: PENDING

## Contents

- Ubuntu Desktop 24.04.4 LTS amd64 analyst workstation baseline.
- One-command setup workflow preserved in the repository.
- MTAW Python virtual environment and launchers.
- JupyterLab configured to bind to loopback with token authentication.
- Controlled OSINT core profile.
- Evidence disk left unpartitioned, without a filesystem, and unmounted.

## Installation And Validation Summary

- Repository commit:
  `fea24326bbae5d7904bddcb66b7fc4a64382d0b2`
- Installer exit status: `0`
- Stage 70 validation: completed successfully
- Required installer stages: passed
- Mandatory validation failures: none observed
- Mandatory validation warnings: none observed
- Block-device inventory: unchanged during installer execution
- Scoped MTAW credential check: passed
- Guest Additions observed: `7.1.10r169112`

## OVA Artifact

- Filename: `MTAW-Workstation-v0.1.0-Ubuntu24.04-amd64.ova`
- Size: `10,006,708,736` bytes
- SHA-256:
  `cfc52f7266c28ccf361bb78abc3978bb27601811e5abe84c4da8b1737747f08a`
- OVA export: completed
- SHA-256 generation: completed
- SHA-256 verification: completed successfully

## Security Defaults

- NAT-only networking is the intended default.
- Shared clipboard should remain disabled.
- Drag-and-drop should remain disabled.
- Shared folders should remain absent unless specifically authorized.
- USB passthrough should remain disabled by default.
- No credentials, API keys, cookies, browser profiles, private certificates, or
  case evidence are included in the repository release records.

## Known Limitations

- Independent OVA re-import acceptance is pending.
- Automated first-boot credential provisioning is not implemented.
- Public release approval is pending.
- Host-control validation is pending.
- Evidence-disk encryption is pending.
- Backup configuration is pending.
- Code signing and release signing are pending.
- Long-term compatibility testing is pending.
- Operational suitability certification is pending.

## Pending Release Work

- Complete independent OVA re-import acceptance testing.
- Resolve first-boot credential provisioning.
- Approve or reject public distribution.
- Record any future signing, tag, or release URL only after it exists.
