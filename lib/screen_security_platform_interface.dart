import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'screen_security_method_channel.dart';

abstract class ScreenSecurityPlatform extends PlatformInterface {
  /// Constructs a ScreenSecurityPlatform.
  ScreenSecurityPlatform() : super(token: _token);

  static final Object _token = Object();

  static ScreenSecurityPlatform _instance = MethodChannelScreenSecurity();

  /// The default instance of [ScreenSecurityPlatform] to use.
  ///
  /// Defaults to [MethodChannelScreenSecurity].
  static ScreenSecurityPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ScreenSecurityPlatform] when
  /// they register themselves.
  static set instance(ScreenSecurityPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Enables screen security to prevent screenshots and screen recording.
  Future<void> enableScreenSecurity() {
    throw UnimplementedError(
        'enableScreenSecurity() has not been implemented.');
  }

  /// Disables screen security, allowing screenshots and screen recording.
  Future<void> disableScreenSecurity() {
    throw UnimplementedError(
        'disableScreenSecurity() has not been implemented.');
  }
}
