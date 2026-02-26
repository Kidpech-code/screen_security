import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_security/screen_security_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelScreenSecurity platform = MethodChannelScreenSecurity();
  const MethodChannel channel = MethodChannel('kidpech_screen_security');

  final List<String> calledMethods = [];

  setUp(() {
    calledMethods.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      calledMethods.add(methodCall.method);
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('enableScreenSecurity sends correct method call', () async {
    await platform.enableScreenSecurity();
    expect(calledMethods, ['enableScreenSecurity']);
  });

  test('disableScreenSecurity sends correct method call', () async {
    await platform.disableScreenSecurity();
    expect(calledMethods, ['disableScreenSecurity']);
  });
}
