# Manifests

`build-specification.yaml` is the machine-readable statement of the locked
MTAW baseline. It records intended settings and implementation status; it does
not prove that a VM has been built or validated.

`apt-packages.txt` and `python-requirements.in` are reviewed input manifests
for the staged guest installer. They describe requested development-VM
dependencies; package availability and compatibility remain unvalidated until
planned clean-VM testing is completed.

`osint-core-tools.yaml` records the controlled OSINT core profile. Stage
`45-osint-core` automatically installs only reviewed Ubuntu APT packages from
that profile. ExifTool remains in the base APT manifest and is not duplicated
in the OSINT stage.

`osint-specialist-tools.yaml` documents optional specialist tools that are not
installed by the base profile. `osint-bookmarks.yaml` is source data for a
curated external-services catalogue; it must not modify browser profiles,
store credentials, or install extensions.

The manifest's repository-check status is changing from `planned` to
`implemented_repository_only` because the check scripts and regression
coverage now exist in this repository. This is an implementation-status
clarification, not a guest, host, workstation, appliance, or OVA validation
claim.
