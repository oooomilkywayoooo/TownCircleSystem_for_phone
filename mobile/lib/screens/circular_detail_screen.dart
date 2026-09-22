import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';

/// 回覧板の詳細・画像拡大表示画面。開いた時点で自動的に既読へ切り替える。
class CircularDetailScreen extends StatefulWidget {
  final Circular circular;
  const CircularDetailScreen({super.key, required this.circular});

  @override
  State<CircularDetailScreen> createState() => _CircularDetailScreenState();
}

class _CircularDetailScreenState extends State<CircularDetailScreen> {
  @override
  void initState() {
    super.initState();
    widget.circular.read = true;
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
                child: Text(c.detail, style: const TextStyle(fontSize: 16, height: 1.6)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.check_circle, color: AppTheme.success, size: 20),
                const SizedBox(width: 6),
                const Text('既読にしました', style: TextStyle(color: AppTheme.success, fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
