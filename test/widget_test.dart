// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:gyurot_market/models/user_profile.dart';
import 'package:gyurot_market/main.dart';

void main() {
  testWidgets('App launch smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ],
        child: const MyApp(),
      ),
    );

    // Verify that the app launches and shows the main screen title or some element.
    // Since we are on the main screen, we expect to see the bottom navigation or home screen content.
    // For now, just checking if it pumps without error.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
