import 'package:flutter/material.dart';
import '../models/circular.dart';
import '../services/api_client.dart';
import '../theme/app_theme.dart';

/// 回覧板の詳細・画像拡大表示画面。開いた時点で自動的に既読へ切り替える。
class CircularDetailScreen extends StatefulWidget {
  final Circular circular;
  const CircularDetailScreen({super.key, required this.circular});

  @override
  State<CircularDetailScreen> createState() => _CircularDetailScreenState();
}

class _CircularDetailScreenState extends State<CircularDetailScreen> {
  bool _markingRead = true;
  bool _markFailed = false;

  @override
  void initState() {
    super.initState();
    _markAsRead();
  }

  Future<void> _markAsRead() async {
    try {
      await ApiClient.post('/circular_read.php', query: {'id': '${widget.circular.id}'});
      widget.circular.isRead = true;
    } catch (e) {
      _markFailed = true;
    } finally {
      if (mounted) setState(() => _markingRead = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.circular;
    return Scaffold(
      appBar: AppBar(title: Text(c.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(c.period, style: const TextStyle(fontSize: 15, color: Colors.black54)),
            const SizedBox(height: 16),
            const Text(
              '画像はピンチ操作で拡大表示できます',
              style: TextStyle(fontSize: 14, color: Colors.black45),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Container(
                  height: 260,
                  width: double.infinity,
                  color: AppTheme.primary.withValues(alpha: 0.08),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.image_rounded, size: 72, color: AppTheme.primary),
                      SizedBox(height: 8),
                      Text('回覧板の画像（サンプル）', style: TextStyle(color: AppTheme.primary)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  c.body ?? '本文はありません',
                  style: const TextStyle(fontSize: 16, height: 1.6),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_markingRead)
              const Row(
                children: [
                  SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                  SizedBox(width: 10),
                  Text('既読にしています…', style: TextStyle(color: Colors.black54, fontSize: 14)),
                ],
              )
            else if (_markFailed)
              const Row(
                children: [
                  Icon(Icons.error_outline, color: AppTheme.danger, size: 20),
                  SizedBox(width: 6),
                  Text('既読の記録に失敗しました', style: TextStyle(color: AppTheme.danger, fontSize: 14)),
                ],
              )
            else
              const Row(
                children: [
                  Icon(Icons.check_circle, color: AppTheme.success, size: 20),
                  SizedBox(width: 6),
                  Text('既読にしました', style: TextStyle(color: AppTheme.success, fontSize: 14)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
