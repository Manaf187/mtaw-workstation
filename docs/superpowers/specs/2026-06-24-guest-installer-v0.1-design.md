# MTAW Guest Installer v0.1 Design

## Goal

Implement a safe, staged Ubuntu guest installer for initial MTAW development
VM testing. Ubuntu Desktop 24.04.4 LTS amd64 is the reference baseline. This
design does not claim workstation, clean-VM, compatibility, appliance, or OVA
validation.

## Architecture

`guest/install/install.sh` is a dispatcher. It parses options, records a run
report, obtains explicit confirmation before any privileged work, and runs
numbered stage scripts in dependency order. `guest/install/lib/common.sh`
provides shared logging, reports, dry-run controls, platform detection,
dependency enforcement, and safe command helpers.

The stages have single responsibilities: preflight; system baseline; core
packages; Python environment; browsers; workspace templates; security defaults;
and validation. A selected later stage includes required preceding stages unless
the dispatcher can prove they have completed in the same run. Unsafe isolated
stage requests fail clearly.

## Platform and modification controls

Preflight accepts Ubuntu 24.04.x amd64 for development testing. It records the
exact release and warns when it differs from 24.04.4. Other families or
architectures fail unless `--allow-unsupported-platform` is supplied. The
override is prominent in logs and reports and never changes validation status
to a success claim.

The installer prompts for the exact word `INSTALL` before modification. `--yes`
is the explicit noninteractive alternative. `--dry-run` is strictly
non-modifying, including no sudo request. Sudo is requested only after
confirmation and only when selected stages need it. No stage reboots the VM.

## Storage safety

The installer takes read-only `lsblk` inventories before and after execution.
It never identifies an evidence disk by order, size, or emptiness. The scripts
contain no partitioning, formatting, mounting, encryption, or filesystem
creation behavior. Validation reports this limitation and records the two
inventories rather than claiming evidence-disk validation.

## State, logs, and reports

The default per-user virtual environment is `~/.local/share/mtaw/venv`; default
run logs and reports are under `~/.local/state/mtaw/`. `--report-dir` overrides
the latter. Each run records UTC start/end times, command options, platform,
selected/completed stages, all required statuses, override use, reboot
recommendation, and before/after block-device inventories.

## Dependencies and tests

Conservative apt and Python dependency manifests are the source for packages.
Package-dependent stages check network resolution and fail clearly if it is
unavailable. Python dependencies are installed only inside the user venv; no
unrestricted system `pip` use is allowed.

Repository tests remain non-root and non-modifying. Fixture environment
overrides support testing unsupported platforms, accepted non-reference point
releases, stage selection, dry-run behavior, ordering, and argument parsing.
