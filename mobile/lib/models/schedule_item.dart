class ScheduleItem {
  final int id;
  final String date; // yyyy-MM-dd
  final String title;
  final String? detail;

  const ScheduleItem({
    required this.id,
    required this.date,
    required this.title,
    required this.detail,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      id: json['id'] as int,
      date: json['date'] as String,
      title: json['title'] as String,
      detail: json['detail'] as String?,
    );
  }
}
