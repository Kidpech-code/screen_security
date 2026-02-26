import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'screen_security_platform_interface.dart';

/// An implementation of [ScreenSecurityPlatform] that uses method channels.
class MethodChannelScreenSecurity extends ScreenSecurityPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('kidpech_screen_security');

  @override
  Future<void> enableScreenSecurity() async {
    await methodChannel.invokeMethod<void>('enableScreenSecurity');
  }

  @override
  Future<void> disableScreenSecurity() async {
    await methodChannel.invokeMethod<void>('disableScreenSecurity');
  }
}
