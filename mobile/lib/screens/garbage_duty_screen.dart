import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';

class GarbageDutyScreen extends StatelessWidget {
  const GarbageDutyScreen({super.key});

  static const _currentMonthLabel = '2026年09月';

  @override
  Widget build(BuildContext context) {
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
                children: const [
                  Text('今月の当番', style: TextStyle(color: Colors.white70, fontSize: 15)),
                  SizedBox(height: 6),
                  Text(_currentMonthLabel, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('1組', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('当番表', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          for (final duty in garbageDuties)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              color: duty.group == CurrentUser.group ? AppTheme.primary.withValues(alpha: 0.08) : null,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: const Icon(Icons.delete_sweep_rounded, color: AppTheme.primary, size: 28),
                title: Text(duty.month, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                trailing: Text(
                  duty.group,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: duty.group == CurrentUser.group ? AppTheme.primary : Colors.black87,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 24),
          Text('順番', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (var i = 0; i < groupList.length; i++) ...[
                    _OrderChip(label: groupList[i], highlight: groupList[i] == CurrentUser.group),
                    if (i != groupList.length - 1)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(Icons.arrow_forward_rounded, color: Colors.black38),
                      ),
                  ],
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(Icons.arrow_forward_rounded, color: Colors.black38),
                  ),
                  const Text('（以後くり返し）', style: TextStyle(fontSize: 13, color: Colors.black54)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderChip extends StatelessWidget {
  final String label;
  final bool highlight;
  const _OrderChip({required this.label, required this.highlight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: highlight ? AppTheme.primary : const Color(0xFFEFF3F8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: highlight ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}
