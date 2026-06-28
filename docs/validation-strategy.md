# Validation Strategy

Most workstation validation described here is planned and not validated. One
observed guest installer run and one reported clean-VM reproducibility
observation are recorded under `docs/validation-runs/`, along with one guest
functional smoke test.

The staged guest installer produces an observed-run report for development
testing. That report is not by itself a compatibility, workstation,
appliance, or OVA validation result.

The final installer stage records guest-side observations as `PASS`, `FAIL`,
`WARN`, `NOT TESTED`, and `NOT APPLICABLE`. A `PASS` identifies only the
specific condition observed during that run; it does not imply that excluded
controls, host settings, package provenance, or analyst suitability passed.

Repository layout, Bash syntax, and repository validation checks are currently
run manually. GitHub Actions CI is not configured. Manual repository checks and
the absence of CI do not validate workstation functionality, host
compatibility, an appliance, or an OVA.

The first reported clean-VM reproducibility observation confirms that the
current automated guest installer path can complete on one clean Ubuntu
24.04.4 amd64 VM. The guest functional smoke test covers MTAW shell activation,
selected Python imports, and JupyterLab loopback startup only. Planned OVA
re-import testing will determine whether a future exported appliance can be
imported and checked again. OVA re-import testing has not been performed.

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
