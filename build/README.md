# Appliance Build and Release Material

This directory holds sanitization and release-evidence material. For
v0.1.0-rc1, an internal controlled release-candidate OVA export, SHA-256
verification, and author-reported OVA re-import acceptance have been recorded.
RC1 build and author-reported re-import used VirtualBox `7.1.10r169112`.
Public release approval, signing, publishing, first-boot credential
provisioning, and VirtualBox `7.2` compatibility testing remain pending.

Any OVA is derived from this repository and must be sanitized before
distribution. It must not contain credentials, tokens, cookies, private
certificates, browser profiles, or case data.
