import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '関連資料',
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          for (final doc in documentFiles)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: const Icon(Icons.picture_as_pdf_rounded, color: AppTheme.danger, size: 32),
                title: Text(doc.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                subtitle: Text('${doc.date} ・ ${doc.size}', style: const TextStyle(fontSize: 13, color: Colors.black54)),
                trailing: FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${doc.name} をダウンロードしました（モック表示）')),
                    );
                  },
                  icon: const Icon(Icons.download_rounded, size: 20),
                  label: const Text('保存'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
