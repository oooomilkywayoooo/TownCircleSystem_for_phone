import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';

class SurveyScreen extends StatelessWidget {
  const SurveyScreen({super.key});

  Future<void> _openForm(BuildContext context, SurveyItem survey) async {
    final uri = Uri.parse(survey.url);
    final ok = await canLaunchUrl(uri) && await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('フォームを開けませんでした（モックURLのため）')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'アンケート',
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          for (final survey in surveyItems)
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
                    Text('公開日：${survey.date}', style: const TextStyle(fontSize: 13, color: Colors.black54)),
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
      ),
    );
  }
}
