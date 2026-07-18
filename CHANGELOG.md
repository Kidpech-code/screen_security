## Unreleased

## 1.1.1 - 2026-07-18

- Fixed iOS window resolution: a present app delegate with a nil `window` no
  longer short-circuits the scene-based window lookup, so `enable()` works in
  scene-based hosts instead of failing with `NO_WINDOW`.
- Added a real iOS enable/disable cycle against the test host window while
  preserving regression coverage for the `NO_WINDOW` error contract.
- Aligned README, API documentation, and CocoaPods metadata with the
  best-effort security claims policy.
- Documented that macOS iPhone Mirroring remained visible on the tested iOS
  26.5.2 device and is not a supported protection boundary.
- Integration tests now disable protection in `tearDown` per testing policy.
- Added professional engineering, contribution, security, and release policies.
- Added CI gates for Dart, Flutter, Android, iOS, and package validation.
- Added trusted-publishing automation for version tags.
- Clarified that screen-capture protection is defense in depth, not a security boundary.
- Fixed the iOS native test target so it compiles against the plugin initializer.
- Updated the example project metadata and native host scaffolding for Flutter 3.44.6.

## 1.1.0

- Added internationalization (i18n) to the example app using `gen-l10n`.
- Example app now supports English (`en`) and Thai (`th`) locales.
- Replaced all hardcoded UI strings in the example app with `AppLocalizations` generated getters.
- Improved error handling in the example app: errors are shown via `SnackBar` (mounted-safe) instead of inline state.
- Added Known Issues section to README: AGP bug with Thai Buddhist Calendar locale during Android builds.

## 1.0.0

- Initial release.
- Added best-effort screenshot and screen-recording protection on iOS and Android.
- Android: `FLAG_SECURE` via `ActivityAware` interface.
- iOS: Secure `UITextField` layer injection without replacing the application window.
- Simple `enable()` / `disable()` Dart API.
