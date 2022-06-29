import 'package:board/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Tap add note button smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byType(SimpleDialog), findsOneWidget);
  });
}
