# Modern Threat Analyst Workstation

MTAW is a reproducible, security-conscious Ubuntu analyst workstation project
supporting *The Modern Threat Analyst: A Practical Guide to National Security,
OSINT, Strategic Warning, and Critical Infrastructure Intelligence* by Manaf
M. Mohamed.

## Status

Version `0.1.0-dev` is an unvalidated development baseline. The staged guest
installer has one observed Ubuntu 24.04.4 amd64 development-VM run and one
reported clean-VM reproducibility observation recorded under
`docs/validation-runs/`. A guest functional smoke test is also recorded there.
No MTAW workstation, OVA, release, checksum, compatibility result,
host-control validation, or operational validation result exists at this
stage.

The repository includes a controlled OSINT core profile, optional specialist
profile records, and a source-data bookmark catalogue. These records do not
claim that a workstation has been built or operationally validated.

## Repository-first model

This repository is the source of truth. It will eventually define how a clean
Ubuntu VM is configured, validated, sanitized, and exported. A future OVA is a
derived delivery artifact; it is not the authoritative build definition and is
not a substitute for reproducibility evidence.

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
