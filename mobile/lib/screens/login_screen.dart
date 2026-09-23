import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../services/session.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('メールアドレスとパスワードを入力してください')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final data = await ApiClient.post('/auth/login.php', body: {
        'email': email,
        'password': password,
      });
      Session.instance.applyLogin(
        token: data['token'] as String,
        member: data['member'] as Map<String, dynamic>,
      );
      // ログインのレスポンスはgroup_nameを含まない要約情報のため、/me.phpで完全なプロフィールを補う。
      try {
        final me = await ApiClient.get('/me.php');
        Session.instance.applyMember(me as Map<String, dynamic>);
      } catch (_) {
        // 補完に失敗しても致命的ではないため、ログイン自体は続行する。
      }
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('サーバーに接続できませんでした。しばらくしてから再度お試しください。')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _requestPasswordReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('メールアドレスを入力してください')),
      );
      return;
    }
    try {
      await ApiClient.post('/auth/password_reset_request.php', body: {'email': email});
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('パスワード再設定用のメールを送信しました（登録されている場合）')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('サーバーに接続できませんでした')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const Icon(Icons.groups_rounded, size: 72, color: AppTheme.primary),
              const SizedBox(height: 16),
              Text(
                '町内会システム',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              const Text(
                '一般会員ログイン',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 40),
              const Text('メールアドレス', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(hintText: 'example@mail.com'),
              ),
              const SizedBox(height: 20),
              const Text('パスワード', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscure,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'パスワードを入力',
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, size: 26),
                    tooltip: _obscure ? 'パスワードを表示' : 'パスワードを隠す',
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _submitting ? null : _requestPasswordReset,
                  child: const Text('パスワードをお忘れの方'),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _submitting ? null : _login,
                child: _submitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                      )
                    : const Text('ログイン'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _submitting
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
                        );
                      },
                child: const Text('新規登録はこちら'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
