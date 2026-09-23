import 'package:flutter/material.dart';
import '../models/document_file.dart';
import '../services/api_client.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  late Future<List<DocumentFile>> _future = _load();

  Future<List<DocumentFile>> _load() async {
    final data = await ApiClient.get('/documents.php') as List;
    return data.map((e) => DocumentFile.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '関連資料',
      body: FutureBuilder<List<DocumentFile>>(
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
          final documents = snapshot.data!;
          if (documents.isEmpty) {
            return const Center(child: Text('資料はありません', style: TextStyle(color: Colors.black54)));
          }
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              for (final doc in documents)
                Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: const Icon(Icons.picture_as_pdf_rounded, color: AppTheme.danger, size: 32),
                    title: Text(doc.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      doc.sizeLabel.isEmpty ? doc.uploadedAt : '${doc.uploadedAt} ・ ${doc.sizeLabel}',
                      style: const TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                    trailing: FilledButton.icon(
                      onPressed: () {
                        final message = doc.filePath == null
                            ? 'このファイルはまだアップロードされていません'
                            : '${doc.name} をダウンロードしました';
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                      },
                      icon: const Icon(Icons.download_rounded, size: 20),
                      label: const Text('保存'),
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
