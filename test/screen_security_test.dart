import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:screen_security/screen_security.dart';
import 'package:screen_security/screen_security_method_channel.dart';
import 'package:screen_security/screen_security_platform_interface.dart';

/// A fully instrumented fake that tracks calls and can simulate errors.
class _FakePlatform
    with MockPlatformInterfaceMixin
    implements ScreenSecurityPlatform {
  bool isEnabled = false;
  int enableCallCount = 0;
  int disableCallCount = 0;
  Exception? errorToThrow;

  @override
  Future<void> enableScreenSecurity() async {
    if (errorToThrow != null) throw errorToThrow!;
    isEnabled = true;
    enableCallCount++;
  }

  @override
  Future<void> disableScreenSecurity() async {
    if (errorToThrow != null) throw errorToThrow!;
    isEnabled = false;
    disableCallCount++;
  }
}

/// Concrete subclass that delegates to the abstract default implementations,
/// which throw [UnimplementedError]. Used to verify the platform contract.
class _DefaultPlatform extends ScreenSecurityPlatform {}

void main() {
  late ScreenSecurity screenSecurity;
  late _FakePlatform fakePlatform;
  late ScreenSecurityPlatform savedPlatform;

  setUp(() {
    savedPlatform = ScreenSecurityPlatform.instance;
    fakePlatform = _FakePlatform();
    ScreenSecurityPlatform.instance = fakePlatform;
    screenSecurity = ScreenSecurity();
  });

  tearDown(() {
    ScreenSecurityPlatform.instance = savedPlatform;
  });

  // ──────────────────────────────────────────────────────────────
  // Platform interface contract
  // ──────────────────────────────────────────────────────────────
  group('ScreenSecurityPlatform', () {
    test('default instance is MethodChannelScreenSecurity', () {
      expect(savedPlatform, isA<MethodChannelScreenSecurity>());
    });

    test(
      'enableScreenSecurity throws UnimplementedError when not overridden',
      () {
        final platform = _DefaultPlatform();
        expect(
          platform.enableScreenSecurity,
          throwsA(isA<UnimplementedError>()),
        );
      },
    );

    test(
      'disableScreenSecurity throws UnimplementedError when not overridden',
      () {
        final platform = _DefaultPlatform();
        expect(
          platform.disableScreenSecurity,
          throwsA(isA<UnimplementedError>()),
        );
      },
    );
  });

  // ──────────────────────────────────────────────────────────────
  // ScreenSecurity.enable()
  // ──────────────────────────────────────────────────────────────
  group('ScreenSecurity.enable()', () {
    test('delegates to platform enableScreenSecurity', () async {
      await screenSecurity.enable();
      expect(fakePlatform.isEnabled, isTrue);
    });

    test('completes normally when platform succeeds', () async {
      await expectLater(screenSecurity.enable(), completes);
    });

    test('increments call count on every invocation', () async {
      await screenSecurity.enable();
      await screenSecurity.enable();
      expect(fakePlatform.enableCallCount, 2);
    });

    test('propagates exceptions thrown by the platform', () async {
      fakePlatform.errorToThrow = Exception('native enable failed');
      await expectLater(
        screenSecurity.enable(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('native enable failed'),
          ),
        ),
      );
    });
  });

  // ──────────────────────────────────────────────────────────────
  // ScreenSecurity.disable()
  // ──────────────────────────────────────────────────────────────
  group('ScreenSecurity.disable()', () {
    test('delegates to platform disableScreenSecurity', () async {
      fakePlatform.isEnabled = true;
      await screenSecurity.disable();
      expect(fakePlatform.isEnabled, isFalse);
    });

    test('completes normally when platform succeeds', () async {
      await expectLater(screenSecurity.disable(), completes);
    });

    test('increments call count on every invocation', () async {
      await screenSecurity.disable();
      await screenSecurity.disable();
      expect(fakePlatform.disableCallCount, 2);
    });

    test('propagates exceptions thrown by the platform', () async {
      fakePlatform.errorToThrow = Exception('native disable failed');
      await expectLater(
        screenSecurity.disable(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('native disable failed'),
          ),
        ),
      );
    });
  });

  // ──────────────────────────────────────────────────────────────
  // State transition sequences
  // ──────────────────────────────────────────────────────────────
  group('state transitions', () {
    test('enable → disable reflects correct final state', () async {
      await screenSecurity.enable();
      expect(fakePlatform.isEnabled, isTrue);

      await screenSecurity.disable();
      expect(fakePlatform.isEnabled, isFalse);
    });

    test('disable → enable reflects correct final state', () async {
      await screenSecurity.disable();
      expect(fakePlatform.isEnabled, isFalse);

      await screenSecurity.enable();
      expect(fakePlatform.isEnabled, isTrue);
    });

    test('repeated enable/disable cycles track all calls', () async {
      const cycles = 3;
      for (var i = 0; i < cycles; i++) {
        await screenSecurity.enable();
        await screenSecurity.disable();
      }
      expect(fakePlatform.enableCallCount, cycles);
      expect(fakePlatform.disableCallCount, cycles);
      expect(fakePlatform.isEnabled, isFalse);
    });
  });
}
