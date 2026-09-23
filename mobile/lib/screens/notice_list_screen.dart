import 'package:flutter/material.dart';
import '../models/notice.dart';
import '../services/api_client.dart';
import '../widgets/notice_card.dart';

/// お知らせ一覧画面。ホーム画面の「お知らせ」もっと見るから遷移する。
class NoticeListScreen extends StatefulWidget {
  const NoticeListScreen({super.key});

  @override
  State<NoticeListScreen> createState() => _NoticeListScreenState();
}

class _NoticeListScreenState extends State<NoticeListScreen> {
  late Future<List<Notice>> _future = _load();

  Future<List<Notice>> _load() async {
    final data = await ApiClient.get('/notices.php') as List;
    return data.map((e) => Notice.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('お知らせ')),
      body: SafeArea(
        child: FutureBuilder<List<Notice>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: TextButton(
                  onPressed: () => setState(() => _future = _load()),
                  child: const Text('取得に失敗しました。タップして再読み込み'),
                ),
              );
            }
            final notices = snapshot.data!;
            if (notices.isEmpty) {
              return const Center(child: Text('お知らせはありません', style: TextStyle(color: Colors.black54)));
            }
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                for (final notice in notices) NoticeCard(notice: notice),
              ],
            );
          },
        ),
      ),
    );
  }
}
