import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import 'circular_list_screen.dart';
import 'schedule_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _currentMonth = '2026-09';

  @override
  Widget build(BuildContext context) {
    final monthlyEvents = scheduleItems.where((s) => s.date.startsWith(_currentMonth)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return AppScaffold(
      title: 'ホーム',
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('${CurrentUser.name} さん、こんにちは', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text('${CurrentUser.group}に所属しています', style: const TextStyle(fontSize: 15, color: Colors.black54)),
          const SizedBox(height: 24),

          _SectionHeader(
            title: 'お知らせ',
            onMore: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CircularListScreen()),
            ),
          ),
          const SizedBox(height: 10),
          for (final notice in notices) _NoticeCard(notice: notice),

          const SizedBox(height: 28),
          _SectionHeader(
            title: '今月の行事（9月）',
            onMore: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ScheduleScreen()),
            ),
          ),
          const SizedBox(height: 10),
          if (monthlyEvents.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('今月の行事予定はありません', style: TextStyle(fontSize: 16, color: Colors.black54)),
              ),
            )
          else
            for (final event in monthlyEvents) _EventTile(event: event),
        ],
      ),
    );
  }
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

class _NoticeCard extends StatelessWidget {
  final Notice notice;
  const _NoticeCard({required this.notice});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.campaign_rounded, color: AppTheme.primary, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(notice.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(notice.body, style: const TextStyle(fontSize: 15, height: 1.5)),
            const SizedBox(height: 8),
            Text(notice.date, style: const TextStyle(fontSize: 13, color: Colors.black45)),
          ],
        ),
      ),
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
