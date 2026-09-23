class MemberGroup {
  final int id;
  final String name;

  const MemberGroup({required this.id, required this.name});

  factory MemberGroup.fromJson(Map<String, dynamic> json) {
    return MemberGroup(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
