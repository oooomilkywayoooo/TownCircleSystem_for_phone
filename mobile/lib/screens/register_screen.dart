import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/group_selector.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  int _familyCount = 1;
  String _selectedGroup = groupList.first;
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _passwordConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('パスワードが一致しません')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('登録が完了しました'),
        content: const Text('ログイン画面からログインしてください。（モック表示）'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('新規登録')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const _FieldLabel('お名前'),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(hintText: '例）山田 太郎'),
                validator: (v) => (v == null || v.isEmpty) ? 'お名前を入力してください' : null,
              ),
              const SizedBox(height: 20),
              const _FieldLabel('住所'),
              TextFormField(
                controller: _addressController,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(hintText: '例）○○県○○市1-2-3'),
                validator: (v) => (v == null || v.isEmpty) ? '住所を入力してください' : null,
              ),
              const SizedBox(height: 20),
              const _FieldLabel('電話番号'),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(hintText: '例）090-1234-5678'),
                validator: (v) => (v == null || v.isEmpty) ? '電話番号を入力してください' : null,
              ),
              const SizedBox(height: 20),
              const _FieldLabel('メールアドレス'),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(hintText: 'example@mail.com'),
                validator: (v) => (v == null || v.isEmpty) ? 'メールアドレスを入力してください' : null,
              ),
              const SizedBox(height: 20),
              const _FieldLabel('家族人数'),
              _FamilyCountStepper(
                value: _familyCount,
                onChanged: (v) => setState(() => _familyCount = v),
              ),
              const SizedBox(height: 20),
              const _FieldLabel('グループ（組）'),
              GroupSelector(
                selected: _selectedGroup,
                onChanged: (g) => setState(() => _selectedGroup = g),
              ),
              const SizedBox(height: 20),
              const _FieldLabel('パスワード'),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscure1,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: '8文字以上で入力してください',
                  suffixIcon: IconButton(
                    icon: Icon(_obscure1 ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure1 = !_obscure1),
                  ),
                ),
                validator: (v) => (v == null || v.length < 8) ? '8文字以上で入力してください' : null,
              ),
              const SizedBox(height: 20),
              const _FieldLabel('パスワード確認'),
              TextFormField(
                controller: _passwordConfirmController,
                obscureText: _obscure2,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'もう一度入力してください',
                  suffixIcon: IconButton(
                    icon: Icon(_obscure2 ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure2 = !_obscure2),
                  ),
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'もう一度入力してください' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(onPressed: _submit, child: const Text('新規登録')),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('ログイン画面に戻る'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }
}

class _FamilyCountStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const _FamilyCountStepper({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB0BAC5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            iconSize: 30,
            color: AppTheme.primary,
            onPressed: value > 1 ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove_circle_outline),
          ),
          Expanded(
            child: Text(
              '$value 人',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            iconSize: 30,
            color: AppTheme.primary,
            onPressed: value < 20 ? () => onChanged(value + 1) : null,
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
    );
  }
}
