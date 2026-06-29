# Modern Threat Analyst Workstation

MTAW is a reproducible, security-conscious Ubuntu analyst workstation project
supporting *The Modern Threat Analyst: A Practical Guide to National Security,
OSINT, Strategic Warning, and Critical Infrastructure Intelligence* by Manaf
M. Mohamed.

## Status

Version `0.1.0-rc1` is a controlled Release Candidate 1 for the Modern Threat
Analyst Workstation. It is derived from repository commit
`fea24326bbae5d7904bddcb66b7fc4a64382d0b2` and targets Ubuntu Desktop
24.04.4 LTS amd64.

Completed RC1 evidence records a successful one-command setup workflow,
successful real installation, successful Stage 70 validation, appliance
sanitization, OVA export, SHA-256 generation, and SHA-256 verification. The
OVA is a derived artifact named
`MTAW-Workstation-v0.1.0-Ubuntu24.04-amd64.ova` with size `10,006,708,736`
bytes and SHA-256
`cfc52f7266c28ccf361bb78abc3978bb27601811e5abe84c4da8b1737747f08a`.
The RC1 build and author-reported re-import acceptance used VirtualBox
`7.1.10r169112`; the project reference baseline remains VirtualBox `7.2`, and
VirtualBox `7.2` compatibility testing is pending.

This is not a final public appliance release. Independent OVA re-import
acceptance is author-reported PASS. First-boot credential provisioning, public
release approval, host-control validation, evidence-disk encryption, backup
configuration, signing, long-term compatibility testing, and operational
suitability certification remain pending.

The repository includes a controlled OSINT core profile, optional specialist
profile records, and a source-data bookmark catalogue. These records do not
claim that a workstation has been built or operationally validated.

## Quick Start

Run MTAW setup from inside an Ubuntu Desktop 24.04.4 LTS amd64 guest VM:

```bash
git clone <repository-url>
cd mtaw-workstation
bash setup-mtaw.sh --dry-run
bash setup-mtaw.sh
```

The top-level `setup-mtaw.sh` command is the public entry point. It is a thin
wrapper around the staged installer in `guest/install/install.sh`.

### Prerequisites

- Ubuntu Desktop 24.04.4 LTS amd64 guest VM.
- Network access for Ubuntu package installation and Python package downloads.
- A VM snapshot before the real installation, for rollback.
- Authorization to make guest-side package and user-environment changes.

### Setup Behavior

- `bash setup-mtaw.sh --dry-run` reviews the planned staged run without writing
  installer reports, state files, or system changes.
- `bash setup-mtaw.sh` runs the real setup and prompts for confirmation before
  privileged stages.
- Reports and logs are written under `~/.local/state/mtaw/`.
- Validation can be rerun with
  `bash guest/install/install.sh --stage 70-validation --yes`.
- No credentials, API keys, cookies, browser profiles, or case evidence are
  included.
- The evidence disk remains untouched.
- Automatic reboot is disabled.
- Rollback is through the VM snapshot taken before setup.

### Release-Readiness Notes

- `BLOCKER`: early installer argument failures could trigger report finalization
  before report directories existed, masking the intended exit code. Fixed in
  the closure pass.
- `NON-BLOCKING`: Chromium remains deferred when absent to avoid Ubuntu's Snap
  transition package path.
- `NON-BLOCKING`: optional repository validators such as ShellCheck, yamllint,
  markdownlint-cli2, and gitleaks may be unavailable locally and are reported
  as `NOT TESTED`.
- `DEFERRED`: host controls, evidence-disk encryption, backups, appliance
  sanitization, OVA export/re-import, release checksums, signing, and
  operational suitability remain outside this closure.

## Repository-first model

This repository is the source of truth. It defines how a clean Ubuntu VM is
configured, validated, sanitized, and exported for RC1. The OVA is a derived
delivery artifact; it is not the authoritative build definition and is not a
substitute for reproducibility evidence.

Three future paths are planned:

1. Automated installation from this repository.
2. A documented manual build from this repository.
3. A prebuilt appliance derived from the same repository.

The current guest scripts can configure an authorized Ubuntu development VM;
they do not configure the VirtualBox host, an evidence disk, or an appliance.
Their observed-run report is not a workstation or appliance validation claim.

For initial development-VM testing, see `guest/install/install.sh --help` and
`docs/manual-build.md`. The staged installer is implemented repository
functionality with one reported clean-VM reproducibility observation; it still
does not establish workstation, host, appliance, or operational validation.

## Repository checks

Repository checks are currently run manually. GitHub Actions CI is not
configured. The absence of CI does not validate the workstation, host
compatibility, appliance, OVA, or operational suitability; those remain
incomplete planned work.

## Repository layout

- `manifests/` — the machine-readable locked baseline and conservative
  dependency placeholders.
- `host/` — Windows and VirtualBox host-side requirements.
- `guest/` — planned Ubuntu guest configuration and repository validation.
- `templates/` — analyst-workflow template guidance, without case data.
- `build/` — planned sanitization and release-evidence materials.
- `docs/` — architecture, security, validation, release, and decision records.

See [architecture documentation](docs/architecture.md) and the
[build specification](manifests/build-specification.yaml).
