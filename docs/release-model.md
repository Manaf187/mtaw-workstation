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
reproducibility. RC1 has an exported OVA and verified SHA-256 digest, but
independent OVA re-import acceptance and first-boot credential provisioning
remain pending.
