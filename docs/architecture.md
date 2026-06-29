# Architecture

## Authoritative build model

MTAW uses a repository-first architecture. Documentation, manifests, scripts,
tests, and validation evidence in this repository define the intended
workstation. A VirtualBox OVA is a derived artifact from a reviewed build and
is not the source of truth.

The planned delivery paths are automated installation, a documented manual
build, and a prebuilt appliance. Each must trace back to the same baseline.

## Boundaries

- `host/windows/` defines Windows and VirtualBox controls.
- `guest/` defines Ubuntu guest-side configuration only.
- `templates/` defines analyst-facing templates without case data.
- `build/` defines sanitization and release evidence.
- `manifests/` defines machine-readable intended settings.

Guest-side scripts cannot prove host settings such as Secure Boot, BitLocker,
VirtualBox networking mode, shared-folder state, or USB passthrough. Those are
host-side validation requirements.

## Guest installer model

`guest/install/install.sh` dispatches numbered stages and records UTC logs,
reports, selected stages, and before/after block-device inventories under the
configured report directory. Shared controls in `guest/install/lib/common.sh`
keep dry runs non-modifying, gate privileged commands, and enforce the system
baseline dependency for later stages. Stage 45 adds the controlled OSINT core
profile after browsers and before workspace templates. Stage 70 reports
guest-side observed state only; it cannot establish host controls, independent
OVA re-import acceptance, or operational suitability.

## Storage model

The planned VM has separate dynamically allocated system and case/evidence
disks. Case/evidence storage is planned to be encrypted and separate from the
120 GiB system VDI. The planned case/evidence VDI capacity is 250 GiB.
