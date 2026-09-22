import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';

class NoticeCard extends StatelessWidget {
  final Notice notice;
  const NoticeCard({super.key, required this.notice});

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
