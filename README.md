# screen_security

[![CI](https://github.com/Kidpech-code/screen_security/actions/workflows/ci.yml/badge.svg)](https://github.com/Kidpech-code/screen_security/actions/workflows/ci.yml)
[![pub package](https://img.shields.io/pub/v/screen_security.svg)](https://pub.dev/packages/screen_security)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A lightweight Flutter plugin that adds best-effort screenshot and screen-recording
protection on Android and iOS. It has no third-party native runtime dependencies.

| Platform | Mechanism |
| --- | --- |
| Android | `WindowManager.LayoutParams.FLAG_SECURE` through `ActivityAware` |
| iOS | Hosts the Flutter view inside the protected rendering layer of a secure `UITextField` |

## Security model

This package is a defense-in-depth control, not a DRM, encryption, or data-loss
prevention boundary. It can reduce exposure through normal operating-system capture
flows, but it cannot prevent every form of copying, including an external camera,
a compromised or modified device, accessibility abuse, or sensitive data leaving
the protected Flutter surface.

The iOS implementation relies on UIKit's secure text rendering behavior and internal
view structure, which Apple can change. Test every supported iOS release and device
class before shipping sensitive workflows. See [SECURITY.md](SECURITY.md) and the
[engineering policy](doc/ENGINEERING_POLICY.md) for the project's assurance rules.

macOS iPhone Mirroring is a known exception: during release validation, an iPhone 13
Pro Max running iOS 26.5.2 continued to expose the protected Flutter surface. The
system did not honor the secure text-field layer or report an active public scene
capture state. Do not treat this package as a protection boundary for iPhone
Mirroring; withhold or permanently redact highly sensitive content at the application
layer. Managed deployments can also disable iPhone Mirroring through device policy.
See Apple's
[device-management restrictions](https://developer.apple.com/documentation/devicemanagement/restrictions).

## Features

- Enables or disables protection at runtime with a small async API.
- Uses Android's standard `FLAG_SECURE` window flag.
- Avoids replacing the iOS application window and keeps the protected Flutter
  surface inside the existing host window.
- Includes Dart, method-channel, Android, iOS, widget, and device integration tests.

## Installation

```yaml
dependencies:
  screen_security: ^1.1.2
```

## Usage

```dart
import 'package:screen_security/screen_security.dart';

final screenSecurity = ScreenSecurity();

await screenSecurity.enable();

// Re-enable capture when the sensitive flow ends.
await screenSecurity.disable();
```

Always pair screen protection with normal application security: least-privilege data
access, authentication, secure storage, redaction, short-lived sessions, and server-side
authorization.

## Platform requirements

| Platform | Declared minimum |
| --- | --- |
| Android | API 24 |
| iOS | 13.0 |
| Flutter | 3.3.0 |
| Dart | 2.18.0 |

The declared Flutter and Dart floors remain compatibility contracts for package
consumers. Maintainer validation uses the Flutter version pinned in `.fvmrc`; releases
must additionally verify the declared floors before claiming continued support.

## Known issue: Android builds under a Thai locale

Some Android Gradle Plugin versions can fail under a Thai (`th_TH`) system locale
because a Buddhist-calendar year exceeds the MS-DOS timestamp range used while
creating an archive.

Add the following flags to the consuming application's existing
`android/gradle.properties` JVM arguments:

```properties
org.gradle.jvmargs=... -Duser.language=en -Duser.country=US
```

Do not replace unrelated JVM arguments already present on the line.

## Development

Install [FVM](https://fvm.app/), then run:

```bash
fvm use
fvm flutter pub get
fvm dart format --output=none --set-exit-if-changed .
fvm flutter analyze --fatal-infos
fvm flutter test
```

Native and release gates are documented in [CONTRIBUTING.md](CONTRIBUTING.md) and
[RELEASING.md](RELEASING.md).

## Contributing and security

- Read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request.
- Report vulnerabilities privately as described in [SECURITY.md](SECURITY.md).
- Project decisions are governed by [doc/ENGINEERING_POLICY.md](doc/ENGINEERING_POLICY.md).

## License

MIT — see [LICENSE](LICENSE).
