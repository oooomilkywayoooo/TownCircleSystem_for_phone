import 'package:flutter/material.dart';
import '../data/mock_data.dart';
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

  List<String> get _months => ['すべて', ...{for (final c in circulars) c.month}];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedMonth == 'すべて'
        ? circulars
        : circulars.where((c) => c.month == _selectedMonth).toList();

    return AppScaffold(
      title: '回覧板',
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
                          for (final m in _months) DropdownMenuItem(value: m, child: Text(m)),
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
            child: ListView.builder(
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
                      color: c.read ? Colors.black38 : AppTheme.primary,
                    ),
                    title: Text(
                      c.title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: c.read ? FontWeight.w500 : FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(c.period, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                    ),
                    trailing: c.read
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
      ),
    );
  }
}
