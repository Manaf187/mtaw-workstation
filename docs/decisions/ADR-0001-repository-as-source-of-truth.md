# ADR-0001: Repository as Source of Truth

## Status

Accepted for the development baseline.

## Context

An analyst workstation may eventually be delivered as a VirtualBox OVA, but a
binary appliance alone cannot adequately communicate its intended settings,
build process, security boundaries, or validation evidence.

## Decision

The MTAW Git repository is authoritative. Manifests, documentation, scripts,
tests, and future validation evidence define the build. A future OVA is a
derived, versioned distribution artifact.

## Consequences

Reproducibility can be pursued through automated installation, manual build,
and appliance delivery. OVA export, re-import, and release evidence remain
planned work and must not be represented as completed by this decision.
