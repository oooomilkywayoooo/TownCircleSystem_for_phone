import 'package:flutter/material.dart';
import '../models/circular.dart';
import '../services/api_client.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import 'circular_detail_screen.dart';

class CircularListScreen extends StatefulWidget {
  const CircularListScreen({super.key});

  @override
  State<CircularListScreen> createState() => _CircularListScreenState();
}

class _CircularListScreenState extends State<CircularListScreen> {
  String _selectedMonth = 'すべて';
  late Future<List<Circular>> _future = _load();

  Future<List<Circular>> _load() async {
    final data = await ApiClient.get('/circulars.php') as List;
    return data.map((e) => Circular.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '回覧板',
      body: FutureBuilder<List<Circular>>(
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

          final circulars = snapshot.data!;
          final months = ['すべて', ...{for (final c in circulars) c.month}];
          final filtered = _selectedMonth == 'すべて'
              ? circulars
              : circulars.where((c) => c.month == _selectedMonth).toList();

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
                              for (final m in months) DropdownMenuItem(value: m, child: Text(m)),
                            ],
                            onChanged: (v) => setState(() => _selectedMonth = v ?? 'すべて'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('回覧板はありません', style: TextStyle(color: Colors.black54)))
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final c = filtered[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              leading: Icon(
                                Icons.description_rounded,
                                size: 32,
                                color: c.isRead ? Colors.black38 : AppTheme.primary,
                              ),
                              title: Text(
                                c.title,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: c.isRead ? FontWeight.w500 : FontWeight.bold,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(c.period, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                              ),
                              trailing: c.isRead
                                  ? const Chip(
                                      label: Text('既読'),
                                      backgroundColor: Color(0xFFE3E6EA),
                                      labelStyle: TextStyle(color: Colors.black54),
                                    )
                                  : const Chip(
                                      label: Text('未読'),
                                      backgroundColor: AppTheme.unreadBadge,
                                      labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                              onTap: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => CircularDetailScreen(circular: c)),
                                );
                                setState(() {});
                              },
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
}
