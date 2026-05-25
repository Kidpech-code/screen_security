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
