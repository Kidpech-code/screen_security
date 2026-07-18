# Engineering Policy

Status: authoritative
Applies to: all source code, documentation, automation, examples, and releases

## 1. Purpose and precedence

`screen_security` is a security-adjacent Flutter plugin. Changes must be conservative,
testable, transparent about limitations, and compatible with both supported native
platforms.

When instructions conflict, use this order:

1. Security and responsible-disclosure requirements in `SECURITY.md`.
2. This engineering policy.
3. Release steps in `RELEASING.md`.
4. Contribution workflow in `CONTRIBUTING.md`.
5. Task-specific instructions that do not weaken items 1-4.

An exception must be documented in the pull request with its owner, reason, risk,
expiry condition, and follow-up issue. Convenience alone is not an exception.

## 2. Product and security model

The package provides defense in depth against ordinary operating-system screenshot
and screen-recording paths. It is not DRM, encryption, authorization, secure storage,
or a complete data-loss prevention system.

Public claims must use evidence-based language such as "best-effort protection" or
"reduces exposure." Documentation, metadata, examples, and release notes must not
claim that capture is impossible or that sensitive data is guaranteed to remain secret.

Known boundaries include:

- External cameras and other physical observation.
- Rooted, jailbroken, compromised, instrumented, or modified operating systems.
- Sensitive content rendered outside the protected Flutter surface.
- Capture or remote-control paths that do not honor secure text rendering, including
  macOS iPhone Mirroring on the tested iOS 26.5.2 configuration.
- Application code that disables protection or exposes the same data elsewhere.
- Future Android, iOS, Flutter, or device behavior that changes the native mechanism.

Security-sensitive applications must combine this package with authentication,
authorization, redaction, secure storage, short-lived data access, audit logging where
appropriate, and server-side enforcement.

## 3. Supported contract

The compatibility contract includes more than the Dart API. Treat each item below as
public unless a release note explicitly says otherwise:

- `ScreenSecurity.enable()` and `ScreenSecurity.disable()` behavior.
- Method-channel name, native method names, and documented error codes.
- Idempotent enable/disable sequences.
- Android `ActivityAware` lifecycle behavior and `FLAG_SECURE` cleanup.
- iOS main-thread behavior, view attachment/restoration, scene lifecycle, and input.
- Declared Dart, Flutter, Android, and iOS minimum versions.
- Privacy manifest statements and package metadata.

Changing a public contract requires a compatibility analysis, tests, migration notes,
and the correct semantic-version increment.

## 4. Platform requirements

### Android

- Apply and clear `FLAG_SECURE` only on a valid current `Activity` window.
- Preserve attach, detach, and configuration-change behavior.
- Return stable `FlutterError` details when no activity is available.
- Do not introduce permissions, services, receivers, exported components, telemetry,
  network access, or storage without explicit security review and documentation.
- Android implementation changes require Kotlin unit tests and an example app build.

### iOS

- Perform UIKit mutations on the main queue.
- Preserve the original Flutter view, bounds, autoresizing, input delivery, keyboard,
  camera, safe area, lifecycle, and scene behavior.
- Treat secure text rendering internals as unstable implementation details. Every
  change to secure-container discovery requires regression tests on supported iOS
  versions and at least one physical-device check before release.
- Do not add private API calls, method swizzling, window replacement, telemetry, or
  data collection without explicit security and App Store compliance review.
- Keep the privacy manifest accurate for both CocoaPods and Swift Package Manager.

### Cross-platform parity

An API available on one supported platform must have defined behavior on the other.
Error codes may be platform-specific only when the underlying failure is genuinely
platform-specific and is documented.

## 5. Quality gates

All required checks must pass before merge. "Works on my machine" is useful evidence,
not a release strategy.

| Change scope | Required evidence |
| --- | --- |
| Any code or config | format, strict analysis, Dart/Flutter tests, clean diff |
| Public Dart API/channel | contract tests, example update, documentation, SemVer review |
| Android native | Kotlin unit tests and Android example build |
| iOS native | iOS native tests and simulator build |
| Capture mechanism | device integration test on affected platform |
| Dependency/toolchain | clean dependency resolution and both native builds |
| Release | every gate above plus publish dry-run and metadata review |

Canonical maintainer commands:

```bash
fvm dart format --output=none --set-exit-if-changed .
fvm flutter analyze --fatal-infos
fvm flutter test

cd example
fvm flutter analyze --fatal-infos
fvm flutter test
fvm flutter build apk --debug
fvm flutter build ios --simulator --debug

cd android
./gradlew :screen_security:testDebugUnitTest

cd ../..
bash tool/run_ios_tests.sh
```

The iOS test runner selects an available iPhone simulator and executes the native test
target. Before a release that changes iOS behavior, also perform a physical-device
capture check.

CI uses the exact Flutter version pinned in `.fvmrc`. The declared minimum SDK versions
remain consumer contracts and must be revalidated before raising or continuing to claim
them. Raising a minimum version is a breaking change unless the old platform is no
longer supported upstream and the release notes clearly explain the exception.

## 6. Testing policy

- Tests must assert observable behavior, error propagation, lifecycle transitions, and
  method-channel compatibility rather than implementation trivia.
- A bug fix must include a regression test that fails before the fix when practical.
- Native security behavior cannot be proven by a mocked channel alone.
- Integration tests must leave protection disabled or restore the prior state in cleanup.
- Do not delete a failing test to make CI green. Correct the behavior or document an
  approved contract change.
- Generated localization files must come from their ARB sources; do not hand-edit them.

## 7. API, compatibility, and versioning

Follow semantic versioning:

- Patch: compatible bug fixes, test/docs improvements, internal hardening.
- Minor: backward-compatible features or newly supported platforms.
- Major: removed/renamed APIs, changed method-channel contract, raised supported floors,
  or behavior changes that require consumer migration.

Deprecate before removal when technically possible. A deprecation must name the
replacement and planned removal window. Keep `pubspec.yaml`, podspec, lockfiles,
README examples, changelog, and Git tag version aligned.

## 8. Dependencies and supply chain

- Prefer Flutter, Dart, Android, and iOS platform APIs over new dependencies.
- Every dependency must have a clear need, compatible license, active maintenance,
  and security review proportional to its privilege.
- Runtime dependencies require stronger justification than dev dependencies.
- GitHub Actions must use least-privilege permissions. Third-party actions must be
  pinned to a full commit SHA and updated through reviewed Dependabot pull requests.
- Never execute code from an untrusted pull request with secrets or a write-capable
  token. Do not use `pull_request_target` to check out pull-request code.
- Do not commit tokens, signing files, credentials, `.env` files, private keys, or
  machine-specific paths.

## 9. Privacy and data handling

The package must remain local-only by default. It must not collect, persist, transmit,
or log screen content, capture events, identifiers, or user data without an explicit
public design review, consent model, privacy documentation, and manifest update.

Error messages must not contain screen content, access tokens, personal data, or host
application secrets.

## 10. Git and review workflow

- Create focused branches and focused pull requests.
- Use Conventional Commits and keep the summary in English within 72 characters.
- Do not mix formatting, generated output, dependency upgrades, and behavior changes
  unless they are inseparable.
- Require at least one review for security behavior, public API, publishing, dependency,
  privacy, or native lifecycle changes when another maintainer is available.
- Resolve all review conversations and pass all required status checks before merge.
- Do not force-push or move a published release tag.
- Protect `main` with pull requests, required CI checks, conversation resolution, and
  blocked force pushes/deletions.

## 11. Documentation standard

Every public behavior change must update the API docs, README/example where relevant,
and `CHANGELOG.md`. Security claims must state assumptions and limitations. Commands
must be executable from the documented directory and identify device-only validation.

## 12. Release and incident policy

Only publish from an immutable `vX.Y.Z` tag that points to reviewed `main`. Use pub.dev
trusted publishing with OIDC and the protected `pub.dev` GitHub environment; never use
a long-lived pub token in CI.

For a suspected vulnerability:

1. Stop public discussion of exploit details.
2. Follow `SECURITY.md` and assess affected versions/platforms.
3. Prepare a minimal private fix and regression test.
4. Publish coordinated remediation and accurate release notes.
5. Review whether claims, tests, or policy allowed the defect to escape.
