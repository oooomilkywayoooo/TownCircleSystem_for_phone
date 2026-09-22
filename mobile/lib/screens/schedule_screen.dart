import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  static const _currentMonth = '2026-09';
  late String _selectedMonth = _currentMonth;

  List<String> get _months {
    final set = {for (final s in scheduleItems) s.date.substring(0, 7)};
    final list = set.toList()..sort();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = scheduleItems.where((s) => s.date.startsWith(_selectedMonth)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return AppScaffold(
      title: 'スケジュール',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                const Text('表示月', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFB0BAC5)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedMonth,
                        isExpanded: true,
                        style: const TextStyle(fontSize: 17, color: Colors.black87),
                        items: [
                          for (final m in _months) DropdownMenuItem(value: m, child: Text(_formatMonth(m))),
                        ],
                        onChanged: (v) => setState(() => _selectedMonth = v ?? _currentMonth),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text('この月の予定はありません', style: TextStyle(fontSize: 16, color: Colors.black54)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final day = item.date.split('-').last;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundColor: AppTheme.primary,
                            child: Text(day, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                          title: Text(item.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          subtitle: Text(item.date, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _formatMonth(String yyyyMM) {
    final parts = yyyyMM.split('-');
    return '${parts[0]}年${int.parse(parts[1])}月';
  }
}
