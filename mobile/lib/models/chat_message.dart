import '../services/session.dart';

class ChatMessage {
  final int id;
  final int? senderMemberId;
  final String senderName;
  final bool senderIsAdmin;
  final String text;
  final String time;

  const ChatMessage({
    required this.id,
    required this.senderMemberId,
    required this.senderName,
    required this.senderIsAdmin,
    required this.text,
    required this.time,
  });

  bool get isMe => !senderIsAdmin && senderMemberId != null && senderMemberId == Session.instance.memberId;

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as int,
      senderMemberId: json['sender_member_id'] as int?,
      senderName: (json['sender_is_admin'] == true || json['sender_is_admin'] == 1)
          ? '事務局'
          : (json['sender_name'] as String? ?? '退会した会員'),
      senderIsAdmin: json['sender_is_admin'] == true || json['sender_is_admin'] == 1,
      text: json['body'] as String,
      time: (json['created_at'] as String).substring(5, 16).replaceFirst('-', '/'),
    );
  }
}
