import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';

class GarbageDutyScreen extends StatelessWidget {
  const GarbageDutyScreen({super.key});

  static const _currentMonthLabel = '2026年09月';

  @override
  Widget build(BuildContext context) {
    final currentDuty = garbageDuties.where((d) => d.month == _currentMonthLabel).firstOrNull;

    return AppScaffold(
      title: 'ゴミ当番確認',
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: AppTheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('今月の当番', style: TextStyle(color: Colors.white70, fontSize: 15)),
                  const SizedBox(height: 6),
                  const Text(_currentMonthLabel, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    currentDuty?.name ?? '未設定',
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  if (currentDuty?.name == CurrentUser.name) ...[
                    const SizedBox(height: 8),
                    const Text('今月はあなたの当番です', style: TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('当番表', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          const Text('月ごとの担当者を確認できます', style: TextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 12),
          for (final duty in garbageDuties)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              color: duty.name == CurrentUser.name ? AppTheme.primary.withValues(alpha: 0.08) : null,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: const Icon(Icons.delete_sweep_rounded, color: AppTheme.primary, size: 28),
                title: Text(duty.month, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                trailing: Text(
                  duty.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: duty.name == CurrentUser.name ? AppTheme.primary : Colors.black87,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
