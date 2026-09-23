import 'package:flutter/material.dart';
import '../screens/chat_screen.dart';
import '../screens/documents_screen.dart';
import '../screens/emergency_contact_screen.dart';
import '../screens/garbage_duty_screen.dart';
import '../screens/home_screen.dart';
import '../screens/circular_list_screen.dart';
import '../screens/login_screen.dart';
import '../screens/opinion_screen.dart';
import '../screens/password_confirm_screen.dart';
import '../screens/schedule_screen.dart';
import '../screens/survey_screen.dart';
import '../services/session.dart';
import '../theme/app_theme.dart';

class DrawerItem {
  final String label;
  final IconData icon;
  final WidgetBuilder builder;
  const DrawerItem({required this.label, required this.icon, required this.builder});
}

final List<DrawerItem> drawerItems = [
  DrawerItem(label: 'ホーム', icon: Icons.home_rounded, builder: (_) => const HomeScreen()),
  DrawerItem(label: '回覧板', icon: Icons.article_rounded, builder: (_) => const CircularListScreen()),
  DrawerItem(label: 'スケジュール', icon: Icons.calendar_month_rounded, builder: (_) => const ScheduleScreen()),
  DrawerItem(label: 'チャット', icon: Icons.chat_bubble_rounded, builder: (_) => const ChatScreen()),
  DrawerItem(label: 'ゴミ当番確認', icon: Icons.delete_sweep_rounded, builder: (_) => const GarbageDutyScreen()),
  DrawerItem(label: '関連資料', icon: Icons.folder_rounded, builder: (_) => const DocumentsScreen()),
  DrawerItem(label: 'アンケート', icon: Icons.fact_check_rounded, builder: (_) => const SurveyScreen()),
  DrawerItem(label: 'ご意見箱', icon: Icons.mail_rounded, builder: (_) => const OpinionScreen()),
  DrawerItem(label: '緊急連絡', icon: Icons.emergency_rounded, builder: (_) => const EmergencyContactScreen()),
  DrawerItem(label: '会員情報変更', icon: Icons.manage_accounts_rounded, builder: (_) => const PasswordConfirmScreen()),
];

class AppDrawer extends StatelessWidget {
  final String currentLabel;
  const AppDrawer({super.key, required this.currentLabel});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              color: AppTheme.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.groups_rounded, color: Colors.white, size: 36),
                  const SizedBox(height: 10),
                  const Text(
                    '町内会システム',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${Session.instance.name ?? ''} さん（${Session.instance.groupName ?? '未所属'}）',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  if (Session.instance.isLeader)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        Session.instance.roleLabel,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  for (final item in drawerItems)
                    _DrawerTile(
                      item: item,
                      selected: item.label == currentLabel,
                    ),
                  const Divider(height: 24),
                  ListTile(
                    leading: const Icon(Icons.logout_rounded, color: AppTheme.danger, size: 28),
                    title: const Text(
                      'ログアウト',
                      style: TextStyle(fontSize: 18, color: AppTheme.danger, fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      Session.instance.clear();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final DrawerItem item;
  final bool selected;
  const _DrawerTile({required this.item, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppTheme.primary.withValues(alpha: 0.08) : Colors.transparent,
      child: ListTile(
        leading: Icon(item.icon, size: 28, color: selected ? AppTheme.primary : Colors.black54),
        title: Text(
          item.label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            color: selected ? AppTheme.primary : Colors.black87,
          ),
        ),
        onTap: () {
          Navigator.of(context).pop();
          if (selected) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: item.builder),
          );
        },
      ),
    );
  }
}
