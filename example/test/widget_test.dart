// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:screen_security_example/main.dart';

void main() {
  testWidgets('App renders with security toggle', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify the app renders the enable button
    expect(find.text('Enable Security'), findsOneWidget);

    // Verify the status text
    expect(find.text('Screen security is OFF'), findsOneWidget);

    // Verify text fields are present for keyboard testing
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
