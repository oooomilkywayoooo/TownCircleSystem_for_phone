/// ログイン中の会員情報とAPIトークンを保持する。
/// アプリ内で唯一のインスタンス（Session.instance）を通じて参照する。
/// 認証系のシンプルなモックだったCurrentUser（mock_data.dart）をAPI接続に伴い置き換えたもの。
class Session {
  Session._();
  static final Session instance = Session._();

  String? token;
  int? memberId;
  String? name;
  String? address;
  String? phone;
  String? email;
  int? familyCount;
  int? groupId;
  String? groupName;
  String role = 'none'; // none / leader / vice_leader

  bool get isLoggedIn => token != null;
  bool get isLeader => role == 'leader';

  static const Map<String, String> roleLabels = {
    'none': '役職なし',
    'leader': '組長',
    'vice_leader': '副組長',
  };

  String get roleLabel => roleLabels[role] ?? role;

  void applyLogin({required String token, required Map<String, dynamic> member}) {
    this.token = token;
    _applyMember(member);
  }

  void applyMember(Map<String, dynamic> member) {
    _applyMember(member);
  }

  void _applyMember(Map<String, dynamic> member) {
    memberId = member['id'] as int?;
    name = member['name'] as String?;
    address = member['address'] as String? ?? address;
    phone = member['phone'] as String? ?? phone;
    email = member['email'] as String? ?? email;
    familyCount = member['family_count'] as int? ?? familyCount;
    groupId = member['group_id'] as int?;
    groupName = member['group_name'] as String? ?? groupName;
    role = member['role'] as String? ?? role;
  }

  void clear() {
    token = null;
    memberId = null;
    name = null;
    address = null;
    phone = null;
    email = null;
    familyCount = null;
    groupId = null;
    groupName = null;
    role = 'none';
  }
}
