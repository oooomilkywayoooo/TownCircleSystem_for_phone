class Circular {
  final int id;
  final String title;
  final String? body;
  final String? imagePath;
  final String startDate;
  final String endDate;
  bool isRead;

  Circular({
    required this.id,
    required this.title,
    required this.body,
    required this.imagePath,
    required this.startDate,
    required this.endDate,
    required this.isRead,
  });

  String get period => '$startDate 〜 $endDate';

  /// スケジュール等の月フィルターと合わせるための yyyy-MM。
  String get month => startDate.substring(0, 7);

  factory Circular.fromJson(Map<String, dynamic> json) {
    final rawRead = json['is_read'];
    return Circular(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String?,
      imagePath: json['image_path'] as String?,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      isRead: rawRead == true || rawRead == 1,
    );
  }
}
