# MTAW Repository Foundation Design

## Purpose

Establish the authoritative, auditable source repository for the Modern Threat
Analyst Workstation (MTAW). This is a development baseline only; it does not
build, validate, distribute, or release a workstation or appliance.

## Decisions

- The Git repository is authoritative. Any future OVA is a derived artifact
  and cannot replace the build instructions, manifests, validation evidence,
  or release records held here.
- The locked baseline is represented in prose and in a machine-readable build
  specification. Changes to baseline values require an explicit documented
  decision rather than silent edits.
- Host controls remain documented under `host/windows/`; guest scripts do not
  attempt to configure or conclusively validate Windows or VirtualBox controls.
- The initial guest installer is a safe dispatcher and preflight framework.
  It makes no system changes, and therefore is not a workstation installer.
- Repository tests validate layout and shell syntax. A repository validation
  command reports `PASS`, `FAIL`, `WARN`, or `NOT TESTED` and never treats an
  unavailable check as passed.
- CI performs static repository quality checks only. It has read-only contents
  permission, does not deploy, release, publish, sign, or upload VM artifacts.

## Structure

- Root files communicate project status, contribution, security, change, and
  agent-operating rules.
- `docs/` records architecture, security, build process, validation strategy,
  release model, first-boot model, licensing status, and decisions.
- `manifests/` holds conservative dependency placeholders and the locked build
  specification.
- `host/`, `guest/`, `templates/`, and `build/` separate host configuration,
  guest configuration, analyst templates, and appliance lifecycle material.
- `tests/` contains portable Bash checks for the repository foundation.

## Safety and Scope Boundaries

No VM, OVA, package installation, credential, evidence, private material,
network exposure, operational test result, release, or publishing function is
introduced. Prohibited VM artifacts, packet captures, database dumps, large
binaries, secrets, browser material, and personal paths are excluded and
checked.

## Verification

The bootstrap will be verified with repository-layout and Bash syntax tests,
the repository validation command, available static linters, a prohibited
artifact scan, a secret-pattern scan, tree inspection, diff inspection, and
Git status. Checks unavailable in the local environment will be recorded as
`NOT TESTED`.
