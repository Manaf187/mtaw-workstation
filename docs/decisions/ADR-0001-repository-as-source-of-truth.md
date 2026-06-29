# ADR-0001: Repository as Source of Truth

## Status

Accepted for the development baseline.

## Context

An analyst workstation may be delivered as a VirtualBox OVA, but a binary
appliance alone cannot adequately communicate its intended settings, build
process, security boundaries, or validation evidence.

## Decision

The MTAW Git repository is authoritative. Manifests, documentation, scripts,
tests, and validation evidence define the build. An OVA is a derived,
versioned distribution artifact.

## Consequences

Reproducibility can be pursued through automated installation, manual build,
and appliance delivery. OVA export and release evidence are recorded separately
from this decision. Re-import acceptance remains a separate validation result
and must not be represented as completed by this decision.
