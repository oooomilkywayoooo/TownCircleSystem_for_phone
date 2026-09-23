import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../widgets/app_scaffold.dart';

class OpinionScreen extends StatefulWidget {
  const OpinionScreen({super.key});

  @override
  State<OpinionScreen> createState() => _OpinionScreenState();
}

class _OpinionScreenState extends State<OpinionScreen> {
  final _controller = TextEditingController();
  bool _anonymous = false;
  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ご意見の内容を入力してください')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      await ApiClient.post('/opinions.php', body: {
        'body': _controller.text.trim(),
        'is_anonymous': _anonymous,
      });
      if (!mounted) return;
      final anonymous = _anonymous;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('送信しました'),
          content: Text(anonymous ? '匿名でご意見を送信しました。ご協力ありがとうございました。' : 'ご意見を送信しました。ご協力ありがとうございました。'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _controller.clear();
                  _anonymous = false;
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('サーバーに接続できませんでした')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'ご意見箱',
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            '町内会運営に関するご意見・ご要望をお寄せください。',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            maxLines: 8,
            style: const TextStyle(fontSize: 17),
            decoration: const InputDecoration(
              hintText: 'ご意見を入力してください',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: SwitchListTile(
              value: _anonymous,
              onChanged: (v) => setState(() => _anonymous = v),
              title: const Text('匿名で送信する', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              subtitle: const Text('氏名を管理者に伝えずに送信します', style: TextStyle(fontSize: 13)),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                  )
                : const Text('送信する'),
          ),
        ],
      ),
    );
  }
}
