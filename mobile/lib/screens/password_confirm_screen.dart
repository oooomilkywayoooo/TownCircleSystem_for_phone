import 'package:flutter/material.dart';
import 'profile_edit_screen.dart';

/// 会員情報変更画面を開く前に、現在のパスワードを確認するためのゲート画面。
/// モックのため、8文字以上入力すれば認証成功として扱う。
class PasswordConfirmScreen extends StatefulWidget {
  const PasswordConfirmScreen({super.key});

  @override
  State<PasswordConfirmScreen> createState() => _PasswordConfirmScreenState();
}

class _PasswordConfirmScreenState extends State<PasswordConfirmScreen> {
  final _controller = TextEditingController();
  bool _obscure = true;
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirm() {
    if (_controller.text.length < 8) {
      setState(() => _errorText = 'パスワードが正しくありません');
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ProfileEditScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('本人確認')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              const Icon(Icons.lock_outline_rounded, size: 56, color: Colors.black54),
              const SizedBox(height: 16),
              const Text(
                '会員情報を変更するため、\n現在のパスワードを入力してください。',
                style: TextStyle(fontSize: 17, height: 1.5),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _controller,
                obscureText: _obscure,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: '現在のパスワード',
                  errorText: _errorText,
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                onSubmitted: (_) => _confirm(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _confirm, child: const Text('確認して進む')),
            ],
          ),
        ),
      ),
    );
  }
}
