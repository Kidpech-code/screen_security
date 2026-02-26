## 1.0.0

* Initial release.
* Prevent screen capturing and recording on iOS and Android.
* Android: `FLAG_SECURE` via `ActivityAware` interface.
* iOS: Secure `UITextField` layer injection — no camera-black-screen conflict.
* Simple `enable()` / `disable()` Dart API.
