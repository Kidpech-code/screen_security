import 'screen_security_platform_interface.dart';

/// A Flutter plugin that provides best-effort screen-capture protection
/// on both iOS and Android.
class ScreenSecurity {
  /// Enables best-effort screen-capture protection.
  ///
  /// On Android, this sets `FLAG_SECURE` on the window.
  /// On iOS, this injects the Flutter view into a secure text field layer
  /// to prevent screen capture without affecting camera functionality.
  Future<void> enable() {
    return ScreenSecurityPlatform.instance.enableScreenSecurity();
  }

  /// Disables screen protection, restoring normal screenshot/recording behavior.
  Future<void> disable() {
    return ScreenSecurityPlatform.instance.disableScreenSecurity();
  }
}
