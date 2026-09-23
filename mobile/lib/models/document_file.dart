class DocumentFile {
  final int id;
  final String name;
  final String? filePath;
  final int fileSizeBytes;
  final String uploadedAt;

  const DocumentFile({
    required this.id,
    required this.name,
    required this.filePath,
    required this.fileSizeBytes,
    required this.uploadedAt,
  });

  String get sizeLabel {
    if (fileSizeBytes <= 0) return '';
    final kb = fileSizeBytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(0)}KB';
    return '${(kb / 1024).toStringAsFixed(1)}MB';
  }

  factory DocumentFile.fromJson(Map<String, dynamic> json) {
    return DocumentFile(
      id: json['id'] as int,
      name: json['name'] as String,
      filePath: json['file_path'] as String?,
      fileSizeBytes: json['file_size_bytes'] as int? ?? 0,
      uploadedAt: json['uploaded_at'] as String,
    );
  }
}
