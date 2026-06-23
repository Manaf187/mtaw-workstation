# Architecture

## Authoritative build model

MTAW uses a repository-first architecture. Documentation, manifests, scripts,
tests, and future validation evidence in this repository define the intended
workstation. A future VirtualBox OVA is derived from a reviewed build and is
not the source of truth.

The planned delivery paths are automated installation, a documented manual
build, and a prebuilt appliance. Each must trace back to the same baseline.

## Boundaries

- `host/windows/` defines Windows and VirtualBox controls.
- `guest/` defines Ubuntu guest-side configuration only.
- `templates/` defines analyst-facing templates without case data.
- `build/` defines planned sanitization and release evidence.
- `manifests/` defines machine-readable intended settings.

Guest-side scripts cannot prove host settings such as Secure Boot, BitLocker,
VirtualBox networking mode, shared-folder state, or USB passthrough. Those are
host-side validation requirements.

## Storage model

The planned VM has separate dynamically allocated system and case/evidence
disks. Case/evidence storage is planned to be encrypted and separate from the
120 GiB system VDI. The planned case/evidence VDI capacity is 250 GiB.
