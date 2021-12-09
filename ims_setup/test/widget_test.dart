// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;

import 'package:starter_project/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('IMS Setup'), findsOneWidget);
    expect(find.text('Muscle Order: '), findsWidgets);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.import_export));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.edit));
    await tester.tap(find.byIcon(Icons.delete));

  });
}
