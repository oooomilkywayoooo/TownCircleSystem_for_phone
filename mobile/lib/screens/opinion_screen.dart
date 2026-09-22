import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart';

class OpinionScreen extends StatefulWidget {
  const OpinionScreen({super.key});

  @override
  State<OpinionScreen> createState() => _OpinionScreenState();
}

class _OpinionScreenState extends State<OpinionScreen> {
  final _controller = TextEditingController();
  bool _anonymous = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ご意見の内容を入力してください')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('送信しました'),
        content: Text(_anonymous ? '匿名でご意見を送信しました。ご協力ありがとうございました。' : 'ご意見を送信しました。ご協力ありがとうございました。'),
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
          ElevatedButton(onPressed: _submit, child: const Text('送信する')),
        ],
      ),
    );
  }
}
