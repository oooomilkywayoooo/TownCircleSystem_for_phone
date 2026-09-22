import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import 'leader_chat_detail_screen.dart';

const Map<String, String> _roleLabels = {
  'leader': '組長',
  'vice_leader': '副組長',
};

/// 組長用の受信箱。組長とのチャットタブの代わりに、組メンバーを選んで個別にやり取りする。
class LeaderInboxScreen extends StatefulWidget {
  const LeaderInboxScreen({super.key});

  @override
  State<LeaderInboxScreen> createState() => _LeaderInboxScreenState();
}

class _LeaderInboxScreenState extends State<LeaderInboxScreen> {
  @override
  Widget build(BuildContext context) {
    final members = groupMembersDirectory
        .where((m) => m.group == CurrentUser.group && m.name != CurrentUser.name)
        .toList();

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: const Color(0xFFEFF3F8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            '${CurrentUser.group}のメンバーです。選んで個別にやり取りできます。',
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              final thread = leaderDmThreads[member.name] ?? const <ChatMessage>[];
              final last = thread.isNotEmpty ? thread.last : null;
              final needsReply = last != null && !last.isMe;
              final roleLabel = _roleLabels[member.role];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
                    child: Text(
                      member.name.substring(0, 1),
                      style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(member.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                      if (roleLabel != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF3F8),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(roleLabel, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Text(
                    last?.text ?? 'まだメッセージはありません',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  trailing: needsReply
                      ? const Chip(
                          label: Text('未返信'),
                          backgroundColor: AppTheme.unreadBadge,
                          labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        )
                      : (last != null
                          ? Text(last.time, style: const TextStyle(fontSize: 12, color: Colors.black38))
                          : null),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => LeaderChatDetailScreen(memberName: member.name)),
                    );
                    setState(() {});
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
