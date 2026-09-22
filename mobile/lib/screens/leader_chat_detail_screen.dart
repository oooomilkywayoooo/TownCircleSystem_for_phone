import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/chat_panel.dart';

/// 組長が受信箱から特定のメンバーを選んで開く、個別チャット画面。
class LeaderChatDetailScreen extends StatefulWidget {
  final String memberName;
  const LeaderChatDetailScreen({super.key, required this.memberName});

  @override
  State<LeaderChatDetailScreen> createState() => _LeaderChatDetailScreenState();
}

class _LeaderChatDetailScreenState extends State<LeaderChatDetailScreen> {
  // leaderDmThreads内の実体（同一インスタンス）を参照する。コピーすると
  // 送信したメッセージが受信箱の一覧（未返信バッジ・最新メッセージ表示）に反映されないため。
  late final List<ChatMessage> _messages = leaderDmThreads.putIfAbsent(widget.memberName, () => <ChatMessage>[]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.memberName)),
      body: SafeArea(
        child: ChatPanel(
          messages: _messages,
          headerText: '${widget.memberName} さんとの個別チャットです',
          onSend: (text) => setState(() {
            _messages.add(ChatMessage(sender: CurrentUser.name, text: text, time: 'たった今', isMe: true));
          }),
        ),
      ),
    );
  }
}
