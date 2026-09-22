import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/notice_card.dart';

/// お知らせ一覧画面。ホーム画面の「お知らせ」もっと見るから遷移する。
class NoticeListScreen extends StatelessWidget {
  const NoticeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('お知らせ')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            for (final notice in notices) NoticeCard(notice: notice),
          ],
        ),
      ),
    );
  }
}
