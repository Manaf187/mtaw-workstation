# MTAW Agent Instructions

## Authority and scope

This repository is the authoritative source for the Modern Threat Analyst
Workstation (MTAW). Preserve the locked technical baseline in
`manifests/build-specification.yaml` and its supporting documentation. Make
small, reviewable changes and document any intended baseline change before
editing its values.

This repository is currently an unvalidated development baseline. Never invent
validation, compatibility, release, checksum, installer, OVA, or operational
test results.

## Safety and security

- Never add secrets, credentials, passwords, private keys, certificates,
  tokens, cookies, browser profiles, personal paths, personal data, or real
  case evidence.
- Never commit an OVA, VDI, ISO, virtual-machine snapshot, packet capture,
  database dump, or large binary.
- Never add offensive exploitation, persistence, credential theft, malware
  development, or unauthorized-access functionality.
- Keep host-side Windows and VirtualBox controls separate from guest-side
  Ubuntu configuration. Guest scripts cannot verify every host-side control.
- Do not introduce a reusable public default password.

## Engineering rules

- Use UTC timestamps and ISO 8601-compatible names.
- Use explicit error handling, preserve useful logs, and report failures
  clearly.
- Make scripts safe to rerun where practical. Document every destructive
  operation before adding it.
- Bash scripts must use `#!/usr/bin/env bash`, `set -Eeuo pipefail`, quoted
  variables, functions, required-command checks, root-privilege checks where
  needed, UTC log messages, and `--help` for user-facing commands.
- Do not use `curl | bash` or broad error suppression such as `|| true` unless
  it is justified and documented.
- Run all repository checks before committing, inspect the diff, and leave the
  worktree clean.
