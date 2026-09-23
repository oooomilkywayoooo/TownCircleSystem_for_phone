import 'package:flutter/material.dart';
import '../models/garbage_duty.dart';
import '../services/api_client.dart';
import '../services/session.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';

class GarbageDutyScreen extends StatefulWidget {
  const GarbageDutyScreen({super.key});

  @override
  State<GarbageDutyScreen> createState() => _GarbageDutyScreenState();
}

class _GarbageDutyScreenState extends State<GarbageDutyScreen> {
  late final String _currentMonth = _formatMonth(DateTime.now());
  late Future<List<GarbageDuty>> _future = _load();

  static String _formatMonth(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}';

  Future<List<GarbageDuty>> _load() async {
    final data = await ApiClient.get('/garbage_duties.php') as List;
    return data.map((e) => GarbageDuty.fromJson(e as Map<String, dynamic>)).toList();
  }

  bool _isMe(GarbageDuty duty) => duty.memberId != null && duty.memberId == Session.instance.memberId;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'ゴミ当番確認',
      body: FutureBuilder<List<GarbageDuty>>(
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

          final duties = snapshot.data!;
          GarbageDuty? currentDuty;
          for (final d in duties) {
            if (d.month == _currentMonth) {
              currentDuty = d;
              break;
            }
          }
          final parts = _currentMonth.split('-');
          final currentMonthLabel = '${parts[0]}年${parts[1]}月';

          return ListView(
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
                      Text(currentMonthLabel, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        currentDuty?.memberName ?? '未設定',
                        style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      if (currentDuty != null && _isMe(currentDuty)) ...[
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
              if (duties.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('ゴミ当番はまだ登録されていません', style: TextStyle(fontSize: 16, color: Colors.black54)),
                  ),
                )
              else
                for (final duty in duties)
                  Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    color: _isMe(duty) ? AppTheme.primary.withValues(alpha: 0.08) : null,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: const Icon(Icons.delete_sweep_rounded, color: AppTheme.primary, size: 28),
                      title: Text(duty.monthLabel, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                      trailing: Text(
                        duty.memberName ?? '未設定',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _isMe(duty) ? AppTheme.primary : Colors.black87,
                        ),
                      ),
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}
