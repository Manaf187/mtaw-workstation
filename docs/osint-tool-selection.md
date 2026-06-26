# OSINT Tool Selection

MTAW uses the Trace Labs Awesome OSINT repository only as a discovery reference.
The repository is not cloned, vendored, mirrored, or treated as an endorsement.
Each tool must stand on its own maintenance, licensing, packaging, and analyst
safety review.

The automatic core profile is deliberately small. It installs only Ubuntu
24.04-packaged tools that can be obtained through APT verification:

- `ffmpeg` for multimedia inspection and conversion.
- `translate-shell` for command-line translation through external translation
  services.
- `ExifTool` is part of the existing base package manifest and is validated as
  OSINT core capability, but it is not duplicated in the OSINT stage.

Sherlock and GoWitness remain deferred core candidates. Sherlock's upstream
documentation recommends `pipx`, `pip`, `uv`, or Docker for Ubuntu 24.04 and
warns that third-party Ubuntu packages may be broken. GoWitness requires an
approved Go module or release-binary verification policy. Both also need
usage guardrails because they make network requests to external services or
targets.

Specialist tools stay optional and are not installed by the base profile:
SpiderFoot, Maltego, PhoneInfoga, and Instaloader. Reasons include commercial
licensing, API or account requirements, larger dependency surfaces, overlapping
capability, and personal-data or collection-risk considerations.

The bookmark catalogue in `manifests/osint-bookmarks.yaml` is source data only.
The installer must not modify Firefox or Chromium profiles and must not install
browser extensions automatically.
