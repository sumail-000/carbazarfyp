// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:carbazar_app/src/core/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App boots with navigation and hero text', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: CarbazarApp()));
    await tester.pumpAndSettle();

    expect(find.text('Drive the future with verified sellers.'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Auctions'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);
  });
}
