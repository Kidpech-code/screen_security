## Unreleased

- Fixed iOS window resolution: a present app delegate with a nil `window` no
  longer short-circuits the scene-based window lookup, so `enable()` works in
  scene-based and add-to-app hosts instead of failing with `NO_WINDOW`.
- Replaced the iOS `NO_WINDOW` unit test (which asserted the pre-fix lookup
  behavior) with a real enable/disable cycle against the test host window.
- Aligned CocoaPods podspec summary/description with the best-effort security
  claims policy.
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
- Prevent screen capturing and recording on iOS and Android.
- Android: `FLAG_SECURE` via `ActivityAware` interface.
- iOS: Secure `UITextField` layer injection — no camera-black-screen conflict.
- Simple `enable()` / `disable()` Dart API.
