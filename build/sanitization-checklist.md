# Planned Sanitization Checklist

This checklist records required sanitization checks for appliance build review.
The v0.1.0-rc1 release-validation record states that appliance sanitization was
completed for the controlled release candidate. Future appliance builds must
record their own checklist result.

- [ ] Confirm no reusable public default password exists.
- [ ] Remove credentials, tokens, API keys, cookies, private certificates, and
  browser profiles.
- [ ] Remove case data, evidence, personal data, and organization-specific
  infrastructure details.
- [ ] Confirm the separate case/evidence disk is not included unless explicitly
  authorized for a separate controlled process.
- [ ] Confirm shared folders, clipboard, drag-and-drop, USB passthrough, and
  host-drive mapping remain disabled.
- [ ] Record host-side validation status and OVA re-import results.
