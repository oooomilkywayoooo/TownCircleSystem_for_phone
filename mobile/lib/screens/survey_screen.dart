import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/survey_item.dart';
import '../services/api_client.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  late Future<List<SurveyItem>> _future = _load();

  Future<List<SurveyItem>> _load() async {
    final data = await ApiClient.get('/surveys.php') as List;
    return data.map((e) => SurveyItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> _openForm(BuildContext context, SurveyItem survey) async {
    final uri = Uri.parse(survey.googleFormUrl);
    final ok = await canLaunchUrl(uri) && await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('フォームを開けませんでした')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'アンケート',
      body: FutureBuilder<List<SurveyItem>>(
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
          final surveys = snapshot.data!;
          if (surveys.isEmpty) {
            return const Center(child: Text('アンケートはありません', style: TextStyle(color: Colors.black54)));
          }
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              for (final survey in surveys)
                Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.fact_check_rounded, color: AppTheme.primary, size: 26),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(survey.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('公開日：${survey.publishedAt}', style: const TextStyle(fontSize: 13, color: Colors.black54)),
                        const SizedBox(height: 14),
                        ElevatedButton.icon(
                          onPressed: () => _openForm(context, survey),
                          icon: const Icon(Icons.open_in_new_rounded, size: 20),
                          label: const Text('Googleフォームで回答する'),
                        ),
                      ],
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
