class GarbageDuty {
  final int id;
  final String month; // yyyy-MM
  final int? memberId;
  final String? memberName;

  const GarbageDuty({
    required this.id,
    required this.month,
    required this.memberId,
    required this.memberName,
  });

  String get monthLabel {
    final parts = month.split('-');
    return '${parts[0]}年${int.parse(parts[1])}月';
  }

  factory GarbageDuty.fromJson(Map<String, dynamic> json) {
    return GarbageDuty(
      id: json['id'] as int,
      month: json['month'] as String,
      memberId: json['member_id'] as int?,
      memberName: json['member_name'] as String?,
    );
  }
}
