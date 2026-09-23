import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/api_client.dart';
import '../services/session.dart';
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

  List<ChatMessage>? _whole;
  List<ChatMessage>? _leader;
  String? _wholeError;
  String? _leaderError;

  bool get _isLeader => Session.instance.isLeader;

  @override
  void initState() {
    super.initState();
    _loadWhole();
    if (!_isLeader) {
      _loadLeader();
    }
  }

  Future<void> _loadWhole() async {
    setState(() => _wholeError = null);
    try {
      final data = await ApiClient.get('/chat_all.php') as List;
      if (!mounted) return;
      setState(() => _whole = data.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>)).toList());
    } catch (e) {
      if (!mounted) return;
      setState(() => _wholeError = '取得に失敗しました');
    }
  }

  Future<void> _loadLeader() async {
    setState(() => _leaderError = null);
    try {
      final data = await ApiClient.get('/chat_leader.php') as List;
      if (!mounted) return;
      setState(() => _leader = data.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>)).toList());
    } catch (e) {
      if (!mounted) return;
      setState(() => _leaderError = '取得に失敗しました');
    }
  }

  Future<void> _sendWhole(String text) async {
    await ApiClient.post('/chat_all.php', body: {'body': text});
    await _loadWhole();
  }

  Future<void> _sendLeader(String text) async {
    await ApiClient.post('/chat_leader.php', body: {'body': text});
    await _loadLeader();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                _buildPanel(
                  messages: _whole,
                  error: _wholeError,
                  onRetry: _loadWhole,
                  headerText: '町内会全体のチャットです',
                  onSend: _sendWhole,
                ),
                _isLeader
                    ? const LeaderInboxScreen()
                    : _buildPanel(
                        messages: _leader,
                        error: _leaderError,
                        onRetry: _loadLeader,
                        headerText: '${Session.instance.groupName ?? ''}の組長との個別チャットです',
                        onSend: _sendLeader,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanel({
    required List<ChatMessage>? messages,
    required String? error,
    required VoidCallback onRetry,
    required String headerText,
    required Future<void> Function(String) onSend,
  }) {
    if (error != null) {
      return Center(
        child: TextButton(onPressed: onRetry, child: const Text('取得に失敗しました。タップして再読み込み')),
      );
    }
    if (messages == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ChatPanel(messages: messages, headerText: headerText, onSend: onSend);
  }
}
