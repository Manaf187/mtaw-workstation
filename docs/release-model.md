# Release Model

MTAW v0.1.0-rc1 is a controlled release candidate with a traceable derived OVA
artifact, release manifest, checksum record, and validation record. It is not a
final public appliance release.

The repository remains authoritative; the OVA is only one delivery form. It
must not be treated as the only reproducibility path. A release must not
include reusable public credentials, secrets, cookies, private certificates,
browser profiles, or case data.

Integrity, authenticity, correctness, and suitability must be assessed and
recorded separately. A checksum alone can detect mismatch against a trusted
reference but does not establish publisher authenticity.

Release records distinguish functional reproducibility from byte-for-byte
reproducibility. RC1 has an exported OVA and verified SHA-256 digest, and
OVA re-import acceptance is author-reported PASS rather than automated CI,
third-party certification, or production certification. RC1 was built and
author-reported re-imported on VirtualBox `7.1.10r169112`. First-boot
credential provisioning and compatibility with the project reference baseline
VirtualBox `7.2` remain pending.
