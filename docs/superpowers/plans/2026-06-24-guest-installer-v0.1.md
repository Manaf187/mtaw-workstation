# MTAW Guest Installer v0.1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the read-only placeholder with a safe staged Ubuntu guest installer for initial development-VM testing.

**Architecture:** A Bash dispatcher and shared library coordinate numbered stages, reporting, platform checks, confirmation, dry-run behavior, and dependency rules. Stage scripts remain small and use manifests for apt and Python dependencies.

**Tech Stack:** Bash, Ubuntu apt, Python 3.12 virtual environments, JupyterLab 4.x.

---

### Task 1: Installer contract tests

**Files:**
- Create: `tests/test-guest-installer.sh`
- Modify: `tests/test-shell-syntax.sh`

- [ ] Write a failing non-root test that requires all eight stage files, the shared library, supported CLI options, stage ordering, no evidence-disk mutation commands, and no default credentials.
- [ ] Run `bash tests/test-guest-installer.sh` and confirm it fails because the staged framework is absent.
- [ ] Keep the test fixture-only: it must not invoke apt, sudo, mount, or installer modification mode.

### Task 2: Dispatcher, shared library, and preflight

**Files:**
- Create: `guest/install/lib/common.sh`
- Modify: `guest/install/install.sh`, `guest/install/stages/00-preflight.sh`

- [ ] Implement `--help`, `--dry-run`, `--stage`, `--from-stage`, `--report-dir`, `--yes`, and `--allow-unsupported-platform`.
- [ ] Record UTC run metadata, before/after `lsblk` inventories, selected/completed stages, platform details, overrides, and reboot recommendation.
- [ ] Enforce interactive `INSTALL` confirmation before privileged stages; skip sudo in dry-run.
- [ ] Detect Ubuntu 24.04.x amd64, warn for non-24.04.4 point releases, and reject unsupported platforms without the explicit override.
- [ ] Run repository tests and confirm the new contract tests pass.

### Task 3: Functional package and environment stages

**Files:**
- Create: `guest/install/stages/10-system-baseline.sh` through `60-security-defaults.sh`
- Modify: `manifests/apt-packages.txt`, `manifests/python-requirements.in`
- Create: `guest/bin/mtaw-activate`, `guest/bin/mtaw-jupyter`

- [ ] Implement stage dependencies, network checks for download stages, apt upgrades, conservative package installation, per-user venv creation, JupyterLab installation, browser checks, sanitized workspace creation, and read-only security observations.
- [ ] Ensure no stage uses partitioning, formatting, mounting, encryption, filesystem creation, SSH enablement, browser profiles, credentials, or reusable passwords.
- [ ] Run Bash syntax and contract tests.

### Task 4: Validation and documentation

**Files:**
- Create: `guest/install/stages/70-validation.sh`
- Modify: `guest/install/README.md`, `guest/validation/README.md`, `docs/build-workflow.md`, `docs/architecture.md`, `docs/validation-strategy.md`, `README.md`, `manifests/build-specification.yaml`
- Create: `docs/manual-build.md`, `docs/rollback-and-troubleshooting.md`

- [ ] Implement a report using `PASS`, `FAIL`, `WARN`, `NOT TESTED`, and `NOT APPLICABLE` with no claim beyond observed development-VM state.
- [ ] Document manual execution, reference versus development-compatible platforms, rollback limits, stage dependencies, deferred validation, and installer exclusions.

### Task 5: Final manual verification and delivery

**Files:**
- Modify: any files required by verification corrections only

- [ ] Run layout, Bash syntax, installer-contract, repository-validation, YAML parsing, prohibited-artifact, and secret-pattern checks.
- [ ] Record unavailable optional tools as `NOT TESTED`.
- [ ] Inspect the final diff and clean worktree, then commit with `feat: implement staged Ubuntu guest installer` and push `feature/guest-installer-v0.1` without merging.
