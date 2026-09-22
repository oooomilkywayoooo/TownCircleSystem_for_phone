import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:town_circle_app/main.dart';

void main() {
  testWidgets('ログイン画面が表示される', (WidgetTester tester) async {
    await tester.pumpWidget(const TownCircleApp());

    expect(find.text('町内会システム'), findsOneWidget);
    expect(find.text('ログイン'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
