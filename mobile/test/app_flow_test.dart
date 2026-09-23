import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:town_circle_app/main.dart';
import 'package:town_circle_app/services/api_client.dart';
import 'package:town_circle_app/services/session.dart';

import 'support/mock_api.dart';

void main() {
  setUp(() {
    ApiClient.client = buildMockApiClient();
    Session.instance.clear();
  });

  testWidgets('ログイン→ホーム→ドロワーから回覧板→既読化までの一連の操作', (tester) async {
    await tester.pumpWidget(const TownCircleApp());
    await tester.pumpAndSettle();

    // ログイン画面 → ログインボタンでホームへ
    expect(find.text('ログイン'), findsWidgets);
    await tester.enterText(find.byType(TextField).first, 'hanako.suzuki@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'ログイン'));
    await tester.pumpAndSettle();

    expect(find.text('お知らせ'), findsOneWidget);
    expect(find.text('鈴木 花子 さん、こんにちは'), findsOneWidget);

    // ハンバーガーメニューを開いて回覧板へ
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, '回覧板'));
    await tester.pumpAndSettle();

    expect(find.text('自治会費集金のお知らせ'), findsOneWidget);
    expect(find.text('未読'), findsOneWidget);

    // 未読の回覧板を開くと既読になる
    await tester.tap(find.text('自治会費集金のお知らせ'));
    await tester.pumpAndSettle();
    expect(find.text('既読にしました'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('未読'), findsNothing);
  });

  testWidgets('チャット画面でメッセージを送信できる', (tester) async {
    await tester.pumpWidget(const TownCircleApp());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'hanako.suzuki@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'ログイン'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'チャット'));
    await tester.pumpAndSettle();

    expect(find.text('町内会全体'), findsOneWidget);
    expect(find.text('組長とのチャット'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'テスト送信メッセージ');
    await tester.tap(find.byIcon(Icons.send_rounded).first);
    await tester.pumpAndSettle();

    expect(find.text('テスト送信メッセージ'), findsOneWidget);
  });

  testWidgets('新規登録画面の主要項目が表示される', (tester) async {
    tester.view.physicalSize = const Size(800, 2600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TownCircleApp());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(OutlinedButton, '新規登録はこちら'));
    await tester.pumpAndSettle();

    for (final label in ['お名前', '住所', '電話番号', 'メールアドレス', '家族人数', 'グループ（組）', 'パスワード', 'パスワード確認']) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.text('1組'), findsOneWidget);
    expect(find.text('2組'), findsOneWidget);
    expect(find.text('3組'), findsOneWidget);
  });
}
