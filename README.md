# Modern Threat Analyst Workstation

MTAW is a reproducible, security-conscious Ubuntu analyst workstation project
supporting *The Modern Threat Analyst: A Practical Guide to National Security,
OSINT, Strategic Warning, and Critical Infrastructure Intelligence* by Manaf
M. Mohamed.

## Status

Version `0.1.0-dev` is an unvalidated development baseline. No MTAW
workstation, installer, OVA, release, checksum, compatibility result, or
operational validation result exists at this stage.

## Repository-first model

This repository is the source of truth. It will eventually define how a clean
Ubuntu VM is configured, validated, sanitized, and exported. A future OVA is a
derived delivery artifact; it is not the authoritative build definition and is
not a substitute for reproducibility evidence.

Three future paths are planned:

1. Automated installation from this repository.
2. A documented manual build from this repository.
3. A prebuilt appliance derived from the same repository.

The current guest scripts are safe frameworks only. They do not install a
workstation or configure a VM.

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
