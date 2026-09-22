import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/group_selector.dart';

/// 会員情報変更画面。現在の登録情報を表示し、変更がある項目だけ書き換える想定。
class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late final _nameController = TextEditingController(text: CurrentUser.name);
  late final _addressController = TextEditingController(text: CurrentUser.address);
  late final _phoneController = TextEditingController(text: CurrentUser.phone);
  late final _emailController = TextEditingController(text: CurrentUser.email);
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  late int _familyCount = CurrentUser.familyCount;
  late String _selectedGroup = CurrentUser.group;
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
    if (_passwordController.text.isNotEmpty &&
        _passwordController.text != _passwordConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('パスワードが一致しません')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('会員情報を更新しました（モック表示）')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '会員情報変更',
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const _FieldLabel('お名前'),
          TextField(controller: _nameController, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          const _FieldLabel('住所'),
          TextField(controller: _addressController, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          const _FieldLabel('電話番号'),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          const _FieldLabel('メールアドレス'),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          const _FieldLabel('家族人数'),
          Row(
            children: [
              IconButton(
                iconSize: 30,
                onPressed: _familyCount > 1 ? () => setState(() => _familyCount--) : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$_familyCount 人', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(
                iconSize: 30,
                onPressed: _familyCount < 20 ? () => setState(() => _familyCount++) : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _FieldLabel('グループ（組）'),
          GroupSelector(
            selected: _selectedGroup,
            onChanged: (g) => setState(() => _selectedGroup = g),
          ),
          const SizedBox(height: 20),
          const _FieldLabel('パスワード（変更する場合のみ入力）'),
          TextField(
            controller: _passwordController,
            obscureText: _obscure1,
            style: const TextStyle(fontSize: 18),
            decoration: InputDecoration(
              hintText: '8文字以上',
              suffixIcon: IconButton(
                icon: Icon(_obscure1 ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscure1 = !_obscure1),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const _FieldLabel('パスワード確認'),
          TextField(
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
          ),
          const SizedBox(height: 32),
          ElevatedButton(onPressed: _submit, child: const Text('変更する')),
        ],
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
