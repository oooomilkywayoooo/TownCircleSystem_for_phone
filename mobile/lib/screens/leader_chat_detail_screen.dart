import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/api_client.dart';
import '../widgets/chat_panel.dart';

/// 組長が受信箱から特定のメンバーを選んで開く、個別チャット画面。
class LeaderChatDetailScreen extends StatefulWidget {
  final int memberId;
  final String memberName;
  const LeaderChatDetailScreen({super.key, required this.memberId, required this.memberName});

  @override
  State<LeaderChatDetailScreen> createState() => _LeaderChatDetailScreenState();
}

class _LeaderChatDetailScreenState extends State<LeaderChatDetailScreen> {
  List<ChatMessage>? _messages;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final data = await ApiClient.get('/chat_leader.php', query: {'member_id': '${widget.memberId}'}) as List;
      if (!mounted) return;
      setState(() => _messages = data.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>)).toList());
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = '取得に失敗しました');
    }
  }

  Future<void> _send(String text) async {
    await ApiClient.post('/chat_leader.php', body: {'body': text}, query: {'member_id': '${widget.memberId}'});
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.memberName)),
      body: SafeArea(
        child: _error != null
            ? Center(
                child: TextButton(onPressed: _load, child: const Text('取得に失敗しました。タップして再読み込み')),
              )
            : _messages == null
                ? const Center(child: CircularProgressIndicator())
                : ChatPanel(
                    messages: _messages!,
                    headerText: '${widget.memberName} さんとの個別チャットです',
                    onSend: _send,
                  ),
      ),
    );
  }
}
