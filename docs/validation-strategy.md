# Validation Strategy

All workstation validation described here is planned and not validated.

The staged guest installer produces an observed-run report for development
testing. That report is not a clean-VM reproducibility, compatibility,
workstation, appliance, or OVA validation result.

The final installer stage records guest-side observations as `PASS`, `FAIL`,
`WARN`, `NOT TESTED`, and `NOT APPLICABLE`. A `PASS` identifies only the
specific condition observed during that run; it does not imply that excluded
controls, host settings, package provenance, or analyst suitability passed.

Repository layout, Bash syntax, and repository validation checks are currently
run manually. GitHub Actions CI is not configured. Manual repository checks and
the absence of CI do not validate workstation functionality, host
compatibility, an appliance, or an OVA.

Planned clean-VM reproducibility testing will determine whether the documented
automated and manual paths produce a functionally suitable analyst environment.
Planned OVA re-import testing will determine whether a future exported
appliance can be imported and checked again. Neither test has been performed.

The guest installer records before and after `lsblk` inventories without
selecting or changing an evidence disk. Inventory output does not establish
forensic integrity, storage encryption, or host-side disk attachment.

Four concepts must remain distinct:

- **Integrity** asks whether bytes changed from a known reference.
- **Authenticity** asks whether the publisher is the claimed publisher.
- **Correctness** asks whether a result meets specified requirements.
- **Suitability** asks whether it is appropriate for the analyst use case.

A SHA-256 digest can support integrity comparison, but by itself does not
authenticate the publisher. Authentication requires a trusted binding between
the digest and the publisher, such as an approved signing or distribution
process.

Functional reproducibility means independently rebuilding a workstation with
the documented expected behavior. Byte-for-byte reproducibility means producing
identical artifacts. The latter is not assumed for future VM artifacts because
virtual hardware, package sources, timestamps, and build metadata can differ.
