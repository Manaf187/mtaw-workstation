# Validation Strategy

All workstation validation described here is planned and not validated.

Planned clean-VM reproducibility testing will determine whether the documented
automated and manual paths produce a functionally suitable analyst environment.
Planned OVA re-import testing will determine whether a future exported
appliance can be imported and checked again. Neither test has been performed.

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
