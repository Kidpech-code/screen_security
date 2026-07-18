# Security Policy

## Scope

The latest published release is supported for security fixes. Older versions may receive
a fix when impact and adoption justify it, but this is not guaranteed.

This plugin is a defense-in-depth control. A successful capture on a rooted/jailbroken
device, through an external camera, or outside the protected Flutter surface is generally
a documented limitation rather than a vulnerability. Incorrect behavior in a normal,
supported OS capture path, privilege escalation, undeclared data collection, or exposure
caused by the plugin may be a vulnerability.

macOS iPhone Mirroring is a documented limitation. On an iPhone 13 Pro Max running
iOS 26.5.2, Mirroring did not honor the secure `UITextField` rendering layer and did
not report an active public scene-capture state, so protected Flutter content remained
visible. Applications that must cover this path need application-level redaction or a
managed-device policy that disables iPhone Mirroring.

## Report privately

Do not open a public issue containing exploit details, sensitive screenshots, tokens,
personal data, or a proof of concept.

Use GitHub's private vulnerability reporting for this repository. If it is unavailable,
contact the maintainer using the address listed in `ios/screen_security.podspec` with the
subject `screen_security security report`.

Include, when available:

- Affected package version and commit.
- Flutter/Dart, OS, device, and host-app configuration.
- Reproduction steps and expected versus actual behavior.
- Impact and whether special device privileges are required.
- A minimal proof of concept with secrets and personal data removed.
- Any proposed remediation or disclosure deadline.

The maintainer will aim to acknowledge a complete report within 3 business days, provide
an initial assessment within 7 business days, and send progress updates at least every
14 days. These are targets, not a contractual SLA.

## Coordinated disclosure

Allow time for triage, fixes, regression tests, and releases across both platforms. Do not
publish details until a fix is available or a disclosure date has been coordinated. The
project will credit reporters who want attribution and will not credit those who prefer
to remain anonymous.

Never send real credentials, signing keys, production data, or unredacted screen content.
