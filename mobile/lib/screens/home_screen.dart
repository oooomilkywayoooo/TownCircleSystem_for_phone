import 'package:flutter/material.dart';
import '../models/notice.dart';
import '../models/schedule_item.dart';
import '../services/api_client.dart';
import '../services/session.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/notice_card.dart';
import 'notice_list_screen.dart';
import 'schedule_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final String _currentMonth = _formatMonth(DateTime.now());
  late Future<_HomeData> _future = _load();

  static String _formatMonth(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}';

  Future<_HomeData> _load() async {
    final results = await Future.wait([
      ApiClient.get('/notices.php'),
      ApiClient.get('/schedules.php', query: {'month': _currentMonth}),
    ]);
    final notices = (results[0] as List).map((e) => Notice.fromJson(e as Map<String, dynamic>)).toList();
    final events = (results[1] as List).map((e) => ScheduleItem.fromJson(e as Map<String, dynamic>)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return _HomeData(notices: notices, monthlyEvents: events);
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    final monthNumber = int.parse(_currentMonth.split('-').last);

    return AppScaffold(
      title: 'ホーム',
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<_HomeData>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return ListView(
                children: [
                  const SizedBox(height: 80),
                  const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.black38),
                  const SizedBox(height: 12),
                  const Center(child: Text('データを取得できませんでした', style: TextStyle(color: Colors.black54))),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(onPressed: _refresh, child: const Text('再読み込み')),
                  ),
                ],
              );
            }

            final data = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text('${Session.instance.name ?? ''} さん、こんにちは', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text('${Session.instance.groupName ?? '未所属'}に所属しています', style: const TextStyle(fontSize: 15, color: Colors.black54)),
                const SizedBox(height: 24),

                _SectionHeader(
                  title: 'お知らせ',
                  onMore: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NoticeListScreen()),
                  ),
                ),
                const SizedBox(height: 10),
                for (final notice in data.notices) NoticeCard(notice: notice),
                if (data.notices.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('お知らせはありません', style: TextStyle(fontSize: 16, color: Colors.black54)),
                    ),
                  ),

                const SizedBox(height: 28),
                _SectionHeader(
                  title: '今月の行事（$monthNumber月）',
                  onMore: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ScheduleScreen()),
                  ),
                ),
                const SizedBox(height: 10),
                if (data.monthlyEvents.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('今月の行事予定はありません', style: TextStyle(fontSize: 16, color: Colors.black54)),
                    ),
                  )
                else
                  for (final event in data.monthlyEvents) _EventTile(event: event),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HomeData {
  final List<Notice> notices;
  final List<ScheduleItem> monthlyEvents;
  const _HomeData({required this.notices, required this.monthlyEvents});
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onMore;
  const _SectionHeader({required this.title, required this.onMore});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
        TextButton(onPressed: onMore, child: const Text('もっと見る')),
      ],
    );
  }
}

class _EventTile extends StatelessWidget {
  final ScheduleItem event;
  const _EventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    final day = event.date.split('-').last;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
          child: Text(day, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
        ),
        title: Text(event.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
