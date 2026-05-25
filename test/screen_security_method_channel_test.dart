import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_security/screen_security_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MethodChannelScreenSecurity platform;
  const channel = MethodChannel('kidpech_screen_security');

  // Full call log so tests can assert method names, order, and arguments.
  final List<MethodCall> log = [];

  setUp(() {
    log.clear();
    platform = MethodChannelScreenSecurity();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      log.add(call);
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  // ──────────────────────────────────────────────────────────────
  // Channel configuration
  // ──────────────────────────────────────────────────────────────
  group('channel configuration', () {
    test('uses the correct channel name', () {
      expect(platform.methodChannel.name, 'kidpech_screen_security');
    });
  });

  // ──────────────────────────────────────────────────────────────
  // enableScreenSecurity
  // ──────────────────────────────────────────────────────────────
  group('enableScreenSecurity', () {
    test('invokes enableScreenSecurity on the channel', () async {
      await platform.enableScreenSecurity();

      expect(log, hasLength(1));
      expect(log.single.method, 'enableScreenSecurity');
    });

    test('sends no arguments to the channel', () async {
      await platform.enableScreenSecurity();

      expect(log.single.arguments, isNull);
    });

    test('completes without error when channel returns null', () async {
      await expectLater(platform.enableScreenSecurity(), completes);
    });

    test('propagates PlatformException from the native side', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (_) async {
        throw PlatformException(
          code: 'NO_ACTIVITY',
          message: 'Activity is not available',
        );
      });

      await expectLater(
        platform.enableScreenSecurity(),
        throwsA(
          isA<PlatformException>().having((e) => e.code, 'code', 'NO_ACTIVITY'),
        ),
      );
    });
  });

  // ──────────────────────────────────────────────────────────────
  // disableScreenSecurity
  // ──────────────────────────────────────────────────────────────
  group('disableScreenSecurity', () {
    test('invokes disableScreenSecurity on the channel', () async {
      await platform.disableScreenSecurity();

      expect(log, hasLength(1));
      expect(log.single.method, 'disableScreenSecurity');
    });

    test('sends no arguments to the channel', () async {
      await platform.disableScreenSecurity();

      expect(log.single.arguments, isNull);
    });

    test('completes without error when channel returns null', () async {
      await expectLater(platform.disableScreenSecurity(), completes);
    });

    test('propagates PlatformException from the native side', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (_) async {
        throw PlatformException(
          code: 'NO_ACTIVITY',
          message: 'Activity is not available',
        );
      });

      await expectLater(
        platform.disableScreenSecurity(),
        throwsA(
          isA<PlatformException>().having((e) => e.code, 'code', 'NO_ACTIVITY'),
        ),
      );
    });
  });

  // ──────────────────────────────────────────────────────────────
  // Sequential call ordering
  // ──────────────────────────────────────────────────────────────
  group('sequential calls', () {
    test('enable then disable records both calls in order', () async {
      await platform.enableScreenSecurity();
      await platform.disableScreenSecurity();

      expect(log, hasLength(2));
      expect(log[0].method, 'enableScreenSecurity');
      expect(log[1].method, 'disableScreenSecurity');
    });

    test('multiple enable calls each reach the channel', () async {
      await platform.enableScreenSecurity();
      await platform.enableScreenSecurity();
      await platform.enableScreenSecurity();

      expect(log, hasLength(3));
      expect(
        log.map((c) => c.method),
        everyElement('enableScreenSecurity'),
      );
    });

    test('disable → enable → disable records calls in correct order', () async {
      await platform.disableScreenSecurity();
      await platform.enableScreenSecurity();
      await platform.disableScreenSecurity();

      expect(log.map((c) => c.method), [
        'disableScreenSecurity',
        'enableScreenSecurity',
        'disableScreenSecurity',
      ]);
    });
  });
}
