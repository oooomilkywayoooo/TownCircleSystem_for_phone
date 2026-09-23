/// 組長用受信箱（GET /v1/chat_leader_inbox.php）の1行分。
class InboxMember {
  final int memberId;
  final String name;
  final String role; // none / leader / vice_leader
  final String? lastMessage;
  final String? lastMessageAt;
  final bool needsReply;

  const InboxMember({
    required this.memberId,
    required this.name,
    required this.role,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.needsReply,
  });

  factory InboxMember.fromJson(Map<String, dynamic> json) {
    return InboxMember(
      memberId: json['member_id'] as int,
      name: json['name'] as String,
      role: json['role'] as String? ?? 'none',
      lastMessage: json['last_message'] as String?,
      lastMessageAt: json['last_message_at'] as String?,
      needsReply: json['needs_reply'] == true || json['needs_reply'] == 1,
    );
  }
}
