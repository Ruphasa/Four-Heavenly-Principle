// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/main.dart';

void main() {
  testWidgets('App renders Login page', (WidgetTester tester) async {
    // Build app wrapped with ProviderScope as in production.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Verify login header text is present.
    expect(find.text('Jawara Pintar'), findsOneWidget);
    // And the Login button exists.
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
  });
}
