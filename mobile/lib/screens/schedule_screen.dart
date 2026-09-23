import 'package:flutter/material.dart';
import '../models/schedule_item.dart';
import '../services/api_client.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late final String _currentMonth = _formatMonth(DateTime.now());
  late String _selectedMonth = _currentMonth;
  late Future<List<ScheduleItem>> _future = _load();

  static String _formatMonth(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}';

  Future<List<ScheduleItem>> _load() async {
    final data = await ApiClient.get('/schedules.php') as List;
    return data.map((e) => ScheduleItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'スケジュール',
      body: FutureBuilder<List<ScheduleItem>>(
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

          final items = snapshot.data!;
          final monthSet = {for (final s in items) s.date.substring(0, 7), _currentMonth};
          final months = monthSet.toList()..sort();
          final filtered = items.where((s) => s.date.startsWith(_selectedMonth)).toList()
            ..sort((a, b) => a.date.compareTo(b.date));

          return Column(
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
                              for (final m in months) DropdownMenuItem(value: m, child: Text(_formatMonthLabel(m))),
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
          );
        },
      ),
    );
  }

  String _formatMonthLabel(String yyyyMM) {
    final parts = yyyyMM.split('-');
    return '${parts[0]}年${int.parse(parts[1])}月';
  }
}
