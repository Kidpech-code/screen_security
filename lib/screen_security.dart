import 'screen_security_platform_interface.dart';

/// A Flutter plugin to prevent screen capturing and recording
/// on both iOS and Android.
class ScreenSecurity {
  /// Enables screen security.
  ///
  /// On Android, this sets `FLAG_SECURE` on the window.
  /// On iOS, this injects the Flutter view into a secure text field layer
  /// to prevent screen capture without affecting camera functionality.
  Future<void> enable() {
    return ScreenSecurityPlatform.instance.enableScreenSecurity();
  }

  /// Disables screen security, restoring normal screenshot/recording behavior.
  Future<void> disable() {
    return ScreenSecurityPlatform.instance.disableScreenSecurity();
  }
}
