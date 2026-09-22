import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';

class EmergencyContactScreen extends StatelessWidget {
  const EmergencyContactScreen({super.key});

  static const _adminPhone = '0900000000';
  static const _adminEmail = 'admin@towncircle.example.com';

  Future<void> _call(BuildContext context) async {
    final uri = Uri(scheme: 'tel', path: _adminPhone);
    final ok = await canLaunchUrl(uri) && await launchUrl(uri);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('電話アプリを起動できませんでした')),
      );
    }
  }

  Future<void> _mail(BuildContext context) async {
    final uri = Uri(scheme: 'mailto', path: _adminEmail, queryParameters: {'subject': '緊急連絡'});
    final ok = await canLaunchUrl(uri) && await launchUrl(uri);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('メールアプリを起動できませんでした')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '緊急連絡',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: AppTheme.danger.withValues(alpha: 0.08),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: AppTheme.danger, size: 28),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '緊急時は下のボタンから管理者へすぐにご連絡ください。',
                        style: TextStyle(fontSize: 16, height: 1.4, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            _BigActionButton(
              icon: Icons.phone_in_talk_rounded,
              label: '電話で連絡する',
              color: AppTheme.danger,
              onTap: () => _call(context),
            ),
            const SizedBox(height: 20),
            _BigActionButton(
              icon: Icons.email_rounded,
              label: 'メールで連絡する',
              color: AppTheme.primary,
              onTap: () => _mail(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _BigActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _BigActionButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 44),
              const SizedBox(height: 10),
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
