import 'package:flutter/material.dart';
import '../models/inbox_member.dart';
import '../services/api_client.dart';
import '../services/session.dart';
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
  late Future<List<InboxMember>> _future = _load();

  Future<List<InboxMember>> _load() async {
    final data = await ApiClient.get('/chat_leader_inbox.php') as List;
    return data.map((e) => InboxMember.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: const Color(0xFFEFF3F8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            '${Session.instance.groupName ?? ''}のメンバーです。選んで個別にやり取りできます。',
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<InboxMember>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: TextButton(
                    onPressed: () => setState(() => _future = _load()),
                    child: const Text('取得に失敗しました。タップして再読み込み'),
                  ),
                );
              }

              final members = snapshot.data!;
              if (members.isEmpty) {
                return const Center(child: Text('組のメンバーがいません', style: TextStyle(color: Colors.black54)));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
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
                        member.lastMessage ?? 'まだメッセージはありません',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      trailing: member.needsReply
                          ? const Chip(
                              label: Text('未返信'),
                              backgroundColor: AppTheme.unreadBadge,
                              labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            )
                          : (member.lastMessageAt != null
                              ? Text(
                                  member.lastMessageAt!.substring(5, 16).replaceFirst('-', '/'),
                                  style: const TextStyle(fontSize: 12, color: Colors.black38),
                                )
                              : null),
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => LeaderChatDetailScreen(
                              memberId: member.memberId,
                              memberName: member.name,
                            ),
                          ),
                        );
                        setState(() => _future = _load());
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
