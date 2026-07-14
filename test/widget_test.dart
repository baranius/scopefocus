import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:scopefocus/main.dart';

void main() {
  testWidgets('App builds and renders the game widget', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CognitiveLearningApp());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
