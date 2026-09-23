import 'package:flutter/material.dart';
import '../services/api_client.dart';
import 'profile_edit_screen.dart';

/// 会員情報変更画面を開く前に、現在のパスワードを確認するためのゲート画面。
/// PUT /v1/me.php はcurrent_password必須のため、他フィールドを送らない形で
/// このゲートの時点から実際にサーバー側の検証を行う。
class PasswordConfirmScreen extends StatefulWidget {
  const PasswordConfirmScreen({super.key});

  @override
  State<PasswordConfirmScreen> createState() => _PasswordConfirmScreenState();
}

class _PasswordConfirmScreenState extends State<PasswordConfirmScreen> {
  final _controller = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final password = _controller.text;
    if (password.isEmpty) {
      setState(() => _errorText = 'パスワードを入力してください');
      return;
    }

    setState(() {
      _submitting = true;
      _errorText = null;
    });
    try {
      await ApiClient.put('/me.php', body: {'current_password': password});
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ProfileEditScreen(currentPassword: password)),
      );
    } on ApiException catch (e) {
      setState(() => _errorText = e.message);
    } catch (e) {
      setState(() => _errorText = 'サーバーに接続できませんでした');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
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
              ElevatedButton(
                onPressed: _submitting ? null : _confirm,
                child: _submitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                      )
                    : const Text('確認して進む'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
