import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 2, vsync: this);
  final List<ChatMessage> _whole = List.of(wholeGroupChat);
  final List<ChatMessage> _leader = List.of(leaderChat);

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
              tabs: const [
                Tab(text: '町内会全体'),
                Tab(text: '組長とのチャット'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ChatPanel(
                  messages: _whole,
                  headerText: '町内会全体のチャットです',
                  onSend: (text) => setState(() {
                    _whole.add(ChatMessage(sender: CurrentUser.name, text: text, time: _nowLabel(), isMe: true));
                  }),
                ),
                _ChatPanel(
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

class _ChatPanel extends StatefulWidget {
  final List<ChatMessage> messages;
  final String headerText;
  final ValueChanged<String> onSend;
  const _ChatPanel({required this.messages, required this.headerText, required this.onSend});

  @override
  State<_ChatPanel> createState() => _ChatPanelState();
}

class _ChatPanelState extends State<_ChatPanel> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: const Color(0xFFEFF3F8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(widget.headerText, style: const TextStyle(fontSize: 13, color: Colors.black54)),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: widget.messages.length,
            itemBuilder: (context, index) {
              final m = widget.messages[index];
              return _MessageBubble(message: m);
            },
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 4,
                    style: const TextStyle(fontSize: 17),
                    decoration: const InputDecoration(
                      hintText: 'メッセージを入力',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 52,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _send,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.send_rounded, size: 24),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final align = message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = message.isMe ? AppTheme.primary : Colors.white;
    final textColor = message.isMe ? Colors.white : Colors.black87;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: align,
        children: [
          if (!message.isMe)
            Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 4),
              child: Text(message.sender, style: const TextStyle(fontSize: 13, color: Colors.black54)),
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.circular(16),
                    border: message.isMe ? null : Border.all(color: const Color(0xFFE1E5EA)),
                  ),
                  child: Text(message.text, style: TextStyle(fontSize: 16, color: textColor, height: 1.4)),
                ),
              ),
              const SizedBox(width: 6),
              Text(message.time, style: const TextStyle(fontSize: 11, color: Colors.black38)),
            ],
          ),
        ],
      ),
    );
  }
}
