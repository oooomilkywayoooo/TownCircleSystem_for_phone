class Notice {
  final int id;
  final String title;
  final String body;
  final String publishedAt;

  const Notice({
    required this.id,
    required this.title,
    required this.body,
    required this.publishedAt,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      publishedAt: json['published_at'] as String,
    );
  }
}
