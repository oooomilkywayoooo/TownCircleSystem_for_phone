import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';

/// メッセージ一覧＋入力欄のチャット表示。町内会全体チャット・組長との個別チャットの両方で使う。
class ChatPanel extends StatefulWidget {
  final List<ChatMessage> messages;
  final String headerText;
  final ValueChanged<String> onSend;
  const ChatPanel({super.key, required this.messages, required this.headerText, required this.onSend});

  @override
  State<ChatPanel> createState() => _ChatPanelState();
}

class _ChatPanelState extends State<ChatPanel> {
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
          child: widget.messages.isEmpty
              ? const Center(
                  child: Text('まだメッセージはありません', style: TextStyle(fontSize: 15, color: Colors.black45)),
                )
              : ListView.builder(
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
