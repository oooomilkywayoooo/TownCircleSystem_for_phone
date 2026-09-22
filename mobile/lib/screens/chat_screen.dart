import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/chat_panel.dart';
import 'leader_inbox_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 2, vsync: this);
  final List<ChatMessage> _whole = List.of(wholeGroupChat);
  final List<ChatMessage> _leader = List.of(leaderChat);

  bool get _isLeader => CurrentUser.role == 'leader';

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leaderName = groupLeaders[CurrentUser.group] ?? '組長';

    return AppScaffold(
      title: 'チャット',
      body: Column(
        children: [
          Material(
            color: AppTheme.primary,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontSize: 16),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                const Tab(text: '町内会全体'),
                Tab(text: _isLeader ? 'メンバー対応' : '組長とのチャット'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ChatPanel(
                  messages: _whole,
                  headerText: '町内会全体のチャットです',
                  onSend: (text) => setState(() {
                    _whole.add(ChatMessage(sender: CurrentUser.name, text: text, time: _nowLabel(), isMe: true));
                  }),
                ),
                _isLeader
                    ? const LeaderInboxScreen()
                    : ChatPanel(
                        messages: _leader,
                        headerText: '$leaderName さん（${CurrentUser.group}の組長）との個別チャットです',
                        onSend: (text) => setState(() {
                          _leader.add(ChatMessage(sender: CurrentUser.name, text: text, time: _nowLabel(), isMe: true));
                        }),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _nowLabel() => 'たった今';
}
