# First Boot Security Guidance

This document describes the intended first-boot security posture for the
controlled MTAW v0.1.0-rc1 release candidate.

Automated first-boot credential provisioning is not implemented in this
release candidate. No reusable build password is published or documented here.

## Before Import

- Verify the appliance checksum before import.
- Use only an OVA whose SHA-256 matches the release checksum record.
- Confirm the import is authorized for the intended environment.

## Before First Boot

- Confirm NAT-only networking.
- Do not use bridged networking by default.
- Disable shared clipboard.
- Disable drag-and-drop.
- Confirm no shared folders are configured.
- Do not enable host-drive mapping.
- Do not enable USB passthrough unless specifically authorized.

## Credentials

- Change or provision credentials before operational use.
- Do not reuse build credentials.
- Do not store passwords, API keys, cookies, tokens, or private certificates in
  the repository or appliance documentation.

## Evidence Handling

- Do not place case evidence on the system disk.
- Use the separate evidence disk only after it has been configured under
  organizational policy.
- The RC1 evidence disk was recorded as unpartitioned, without a filesystem,
  and unmounted.

## Guest Checks

After boot, verify:

```bash
timedatectl show --property=Timezone --value
ls ~/MTAW-Workspace
mtaw-shell
mtaw-jupyter
```

The timezone should be UTC. The workspace path should exist under
`~/MTAW-Workspace`. Jupyter should bind to loopback and require token
authentication.
