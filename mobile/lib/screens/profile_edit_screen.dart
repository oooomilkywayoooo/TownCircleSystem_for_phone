import 'package:flutter/material.dart';
import '../models/member_group.dart';
import '../services/api_client.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/group_selector.dart';

/// 会員情報変更画面。現在の登録情報を表示し、変更がある項目だけ書き換える想定。
class ProfileEditScreen extends StatefulWidget {
  final String currentPassword;
  const ProfileEditScreen({super.key, required this.currentPassword});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  int _familyCount = 1;
  int? _selectedGroupId;
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _submitting = false;
  bool _loading = true;
  String? _loadError;
  List<MemberGroup> _groups = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        ApiClient.get('/me.php'),
        ApiClient.get('/groups.php'),
      ]);
      final me = results[0] as Map<String, dynamic>;
      final groups = (results[1] as List).map((e) => MemberGroup.fromJson(e as Map<String, dynamic>)).toList();

      _nameController.text = me['name'] as String? ?? '';
      _addressController.text = me['address'] as String? ?? '';
      _phoneController.text = me['phone'] as String? ?? '';
      _emailController.text = me['email'] as String? ?? '';
      _familyCount = me['family_count'] as int? ?? 1;
      _selectedGroupId = me['group_id'] as int?;
      _groups = groups;

      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _loading = false;
        _loadError = 'データを取得できませんでした';
      });
    }
  }

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

  Future<void> _submit() async {
    if (_passwordController.text.isNotEmpty &&
        _passwordController.text != _passwordConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('パスワードが一致しません')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final body = <String, dynamic>{
        'current_password': widget.currentPassword,
        'name': _nameController.text.trim(),
        'address': _addressController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'family_count': _familyCount,
        'group_id': _selectedGroupId,
      };
      if (_passwordController.text.isNotEmpty) {
        body['new_password'] = _passwordController.text;
      }
      await ApiClient.put('/me.php', body: body);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('会員情報を更新しました')),
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
      title: '会員情報変更',
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _loadError != null
              ? Center(child: Text(_loadError!))
              : ListView(
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
                      groups: _groups,
                      selectedId: _selectedGroupId,
                      onChanged: (id) => setState(() => _selectedGroupId = id),
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
                    ElevatedButton(
                      onPressed: _submitting ? null : _submit,
                      child: _submitting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                            )
                          : const Text('変更する'),
                    ),
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
