// Integration tests for the screen_security plugin.
//
// These tests run against the real native implementation on a device or
// emulator and verify the full Dart → MethodChannel → native bridge.

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:screen_security/screen_security.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late ScreenSecurity plugin;

  setUp(() {
    plugin = ScreenSecurity();
  });

  // Policy: integration tests must leave protection disabled in cleanup.
  tearDown(() async {
    await plugin.disable();
  });

  group('enable()', () {
    testWidgets('does not throw on the first call', (tester) async {
      await expectLater(plugin.enable(), completes);
    });

    testWidgets('is idempotent: calling twice does not throw', (tester) async {
      await plugin.enable();
      await expectLater(plugin.enable(), completes);
    });
  });

  group('disable()', () {
    testWidgets('does not throw on the first call', (tester) async {
      await expectLater(plugin.disable(), completes);
    });

    testWidgets('is idempotent: calling twice does not throw', (tester) async {
      await plugin.disable();
      await expectLater(plugin.disable(), completes);
    });
  });

  group('enable ↔ disable cycle', () {
    testWidgets('enable then disable completes successfully', (tester) async {
      await plugin.enable();
      await expectLater(plugin.disable(), completes);
    });

    testWidgets('disable then enable completes successfully', (tester) async {
      await plugin.disable();
      await expectLater(plugin.enable(), completes);
    });

    testWidgets('three full enable/disable cycles all complete successfully', (
      tester,
    ) async {
      for (var i = 0; i < 3; i++) {
        await expectLater(plugin.enable(), completes);
        await expectLater(plugin.disable(), completes);
      }
    });
  });
}
