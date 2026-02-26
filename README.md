# screen_security

A **zero-dependency** Flutter plugin to prevent screen capturing and screen recording on **iOS** and **Android**.

| Platform | Mechanism |
|----------|-----------|
| Android  | `WindowManager.LayoutParams.FLAG_SECURE` via `ActivityAware` |
| iOS      | Injects `FlutterView` into a secure `UITextField` layer (`isSecureTextEntry`), avoiding the common camera-black-screen conflict |

## Features

- Prevent screenshots and screen recording on both platforms
- No external dependencies — pure native implementation
- iOS: Does **not** manipulate the window directly, so camera, keyboard, and SafeArea work correctly
- Android: Uses the standard `FLAG_SECURE` flag
- Simple `enable()` / `disable()` API

## Getting Started

Add the dependency:

```yaml
dependencies:
  screen_security: ^1.0.0
```

## Usage

```dart
import 'package:screen_security/screen_security.dart';

final screenSecurity = ScreenSecurity();

// Enable screen protection
await screenSecurity.enable();

// Disable screen protection
await screenSecurity.disable();
```

## Platform Requirements

| Platform | Minimum Version |
|----------|----------------|
| Android  | API 24 (minSdk) |
| iOS      | 13.0           |
| Flutter  | ≥ 3.3.0        |

## How It Works

### Android
Applies `FLAG_SECURE` to the current `Activity` window, which prevents the system from including app content in screenshots or screen recordings.

### iOS
Creates a custom `UITextField` subclass with `isSecureTextEntry = true` and injects the `FlutterView` into its internal secure layer. This leverages iOS's built-in DRM rendering pipeline to blank out the content during screen capture — without touching the window hierarchy directly, preserving camera, keyboard, and SafeArea behavior.

## Known Issues

### Android build fails with Thai locale (Buddhist Calendar)

If your system locale is set to Thai (`th_TH`), the Android Gradle Plugin (AGP) may fail with:

```
com.google.common.base.VerifyException (no error message)
  at ...MsDosDateTimeUtils.packDate(...)
```

This is a **known AGP bug** where `BuddhistCalendar` returns year 2569 (instead of 2026), which exceeds the MS-DOS date format limit (1980–2107).

**Fix:** Add the following JVM flags to your project's `android/gradle.properties`:

```properties
org.gradle.jvmargs=... -Duser.language=en -Duser.country=US
```

Append `-Duser.language=en -Duser.country=US` to your existing `org.gradle.jvmargs` line.

## License

MIT — see [LICENSE](https://github.com/Kidpech-code/screen_security/blob/main/LICENSE) for details.

