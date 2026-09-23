class SurveyItem {
  final int id;
  final String title;
  final String googleFormUrl;
  final String publishedAt;

  const SurveyItem({
    required this.id,
    required this.title,
    required this.googleFormUrl,
    required this.publishedAt,
  });

  factory SurveyItem.fromJson(Map<String, dynamic> json) {
    return SurveyItem(
      id: json['id'] as int,
      title: json['title'] as String,
      googleFormUrl: json['google_form_url'] as String,
      publishedAt: json['published_at'] as String,
    );
  }
}
