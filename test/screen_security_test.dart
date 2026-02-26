import 'package:flutter_test/flutter_test.dart';
import 'package:screen_security/screen_security.dart';
import 'package:screen_security/screen_security_platform_interface.dart';
import 'package:screen_security/screen_security_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockScreenSecurityPlatform with MockPlatformInterfaceMixin implements ScreenSecurityPlatform {
  bool enabled = false;

  @override
  Future<void> enableScreenSecurity() async {
    enabled = true;
  }

  @override
  Future<void> disableScreenSecurity() async {
    enabled = false;
  }
}

void main() {
  final ScreenSecurityPlatform initialPlatform = ScreenSecurityPlatform.instance;

  test('$MethodChannelScreenSecurity is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelScreenSecurity>());
  });

  test('enable calls platform enableScreenSecurity', () async {
    final screenSecurity = ScreenSecurity();
    final fakePlatform = MockScreenSecurityPlatform();
    ScreenSecurityPlatform.instance = fakePlatform;

    await screenSecurity.enable();
    expect(fakePlatform.enabled, true);
  });

  test('disable calls platform disableScreenSecurity', () async {
    final screenSecurity = ScreenSecurity();
    final fakePlatform = MockScreenSecurityPlatform();
    ScreenSecurityPlatform.instance = fakePlatform;
    fakePlatform.enabled = true;

    await screenSecurity.disable();
    expect(fakePlatform.enabled, false);
  });
}
