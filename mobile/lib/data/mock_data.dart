// この段階では実際の通信・DB接続は行わず、画面確認用のダミーデータのみを保持する。

class CurrentUser {
  static const String name = '鈴木 花子';
  static const String group = '2組';
  static const String address = '○○県○○市2-4-6';
  static const String phone = '090-3333-4444';
  static const String email = 'hanako.suzuki@example.com';
  static const int familyCount = 4;

  /// none=役職なし, leader=組長, vice_leader=副組長。
  /// 組長のときだけチャット画面が「組メンバー選択→個別チャット」の受信箱UIに切り替わる。
  /// 'leader'に変更すると、佐藤太郎(1組の組長)としてメンバー対応(受信箱)画面を確認できる。
  static const String role = 'none';
}

/// 組の一覧（管理者画面と統一した命名）
const List<String> groupList = ['1組', '2組', '3組'];

/// 各組の組長・副組長
const Map<String, String> groupLeaders = {
  '1組': '佐藤 太郎',
  '2組': '田中 一郎',
  '3組': '伊藤 光',
};

const Map<String, String> groupViceLeaders = {
  '1組': '高橋 次郎',
  '2組': '渡辺 久美',
  '3組': '中村 誠',
};

class Notice {
  final String title;
  final String date;
  final String body;
  const Notice({required this.title, required this.date, required this.body});
}

const List<Notice> notices = [
  Notice(
    title: '夏祭りのお知らせ',
    date: '2026-07-01',
    body: '日時：2026年8月1日（土）17:00〜20:00\n場所：町内公園\n出店や盆踊りを予定しています。ぜひご参加ください。',
  ),
  Notice(
    title: '防災訓練について',
    date: '2026-06-15',
    body: '日時：2026年7月20日（月）9:00〜\n場所：町内公園\n避難訓練と消火器の使い方講習を行います。',
  ),
  Notice(
    title: 'ゴミ収集日変更のお知らせ',
    date: '2026-05-20',
    body: '祝日にあたるため、収集日が1日順延となります。詳しくは市の案内をご確認ください。',
  ),
];

class Circular {
  final int id;
  final String title;
  final String period;
  final String month; // yyyy-MM 検索用
  bool read;
  final String detail;
  Circular({
    required this.id,
    required this.title,
    required this.period,
    required this.month,
    required this.read,
    required this.detail,
  });
}

final List<Circular> circulars = [
  Circular(
    id: 1,
    title: '自治会費集金のお知らせ',
    period: '2026/07/01 〜 2026/07/31',
    month: '2026-07',
    read: false,
    detail: '7月分の自治会費集金を行います。各組の組長が集金にお伺いしますので、期間内のお支払いにご協力をお願いします。',
  ),
  Circular(
    id: 2,
    title: '資源ごみ回収カレンダー',
    period: '2026/06/01 〜 2026/06/30',
    month: '2026-06',
    read: true,
    detail: '6月の資源ごみ回収予定日一覧です。缶・びん・ペットボトルは第2・第4水曜日、古紙は第1・第3金曜日です。',
  ),
  Circular(
    id: 3,
    title: '防犯パトロールのお知らせ',
    period: '2026/05/01 〜 2026/05/31',
    month: '2026-05',
    read: true,
    detail: '毎週土曜19時より町内防犯パトロールを実施しています。参加できる方は公民館前に集合してください。',
  ),
];

class ScheduleItem {
  final String date; // yyyy-MM-dd
  final String title;
  const ScheduleItem({required this.date, required this.title});
}

const List<ScheduleItem> scheduleItems = [
  ScheduleItem(date: '2026-09-06', title: '資源ごみ回収'),
  ScheduleItem(date: '2026-09-15', title: '敬老会'),
  ScheduleItem(date: '2026-09-27', title: '町内清掃活動'),
  ScheduleItem(date: '2026-08-01', title: '夏祭り'),
  ScheduleItem(date: '2026-08-10', title: '資源ごみ回収'),
  ScheduleItem(date: '2026-07-05', title: '資源ごみ回収'),
  ScheduleItem(date: '2026-07-20', title: '夏祭り実行委員会'),
];

class ChatMessage {
  final String sender;
  final String text;
  final String time;
  final bool isMe;
  const ChatMessage({
    required this.sender,
    required this.text,
    required this.time,
    required this.isMe,
  });
}

final List<ChatMessage> wholeGroupChat = [
  const ChatMessage(sender: '事務局', text: '来週の町内清掃活動は9/27（日）朝8時からです。', time: '09/20 10:02', isMe: false),
  const ChatMessage(sender: CurrentUser.name, text: '承知しました、参加します。', time: '09/20 10:15', isMe: true),
  const ChatMessage(sender: '佐藤 太郎', text: '軍手を持参いただけると助かります。', time: '09/20 10:20', isMe: false),
];

final List<ChatMessage> leaderChat = [
  ChatMessage(sender: groupLeaders[CurrentUser.group] ?? '組長', text: 'いつもありがとうございます。来月の回覧板は月初にお渡しします。', time: '09/18 08:40', isMe: false),
  const ChatMessage(sender: CurrentUser.name, text: 'ありがとうございます、よろしくお願いします。', time: '09/18 09:02', isMe: true),
];

/// 組長用受信箱で使う、組ごとのメンバー一覧。
class GroupMember {
  final String name;
  final String group;
  final String role; // none / leader / vice_leader
  const GroupMember({required this.name, required this.group, this.role = 'none'});
}

const List<GroupMember> groupMembersDirectory = [
  GroupMember(name: '佐藤 太郎', group: '1組', role: 'leader'),
  GroupMember(name: '高橋 次郎', group: '1組', role: 'vice_leader'),
  GroupMember(name: '中村 美咲', group: '1組'),
  GroupMember(name: '小林 健太', group: '1組'),
  GroupMember(name: '田中 一郎', group: '2組', role: 'leader'),
  GroupMember(name: '渡辺 久美', group: '2組', role: 'vice_leader'),
  GroupMember(name: CurrentUser.name, group: '2組'),
  GroupMember(name: '山本 誠', group: '2組'),
  GroupMember(name: '伊藤 光', group: '3組', role: 'leader'),
  GroupMember(name: '中村 誠', group: '3組', role: 'vice_leader'),
  GroupMember(name: '吉田 真由美', group: '3組'),
];

/// 組長から見た「メンバー個人名 → 組長とのやり取り」の履歴。
/// 組長が受信箱でメンバーを選んで開く個別チャットに対応する（isMeは組長自身の発言かどうか）。
final Map<String, List<ChatMessage>> leaderDmThreads = {
  '高橋 次郎': [
    const ChatMessage(sender: '高橋 次郎', text: '来月の資源ごみ回収、当番表の確認をお願いします。', time: '09/21 14:10', isMe: false),
  ],
  '中村 美咲': [
    const ChatMessage(sender: '中村 美咲', text: '来週の集金、何時頃になりますか？', time: '09/19 11:00', isMe: false),
    const ChatMessage(sender: '佐藤 太郎', text: '土曜の午前中を予定しています。', time: '09/19 11:30', isMe: true),
  ],
  '小林 健太': [],
};

/// ゴミ当番は組単位ではなく会員個人単位で割り当てる。
class GarbageDuty {
  final String month; // yyyy年MM月
  final String name;
  const GarbageDuty({required this.month, required this.name});
}

const List<GarbageDuty> garbageDuties = [
  GarbageDuty(month: '2026年07月', name: '高橋 次郎'),
  GarbageDuty(month: '2026年08月', name: '佐藤 太郎'),
  GarbageDuty(month: '2026年09月', name: CurrentUser.name),
  GarbageDuty(month: '2026年10月', name: '高橋 次郎'),
  GarbageDuty(month: '2026年11月', name: '佐藤 太郎'),
];

class DocumentFile {
  final String name;
  final String date;
  final String size;
  const DocumentFile({required this.name, required this.date, required this.size});
}

const List<DocumentFile> documentFiles = [
  DocumentFile(name: '町内会規約.pdf', date: '2026-04-01', size: '1.2MB'),
  DocumentFile(name: '防災マニュアル.pdf', date: '2026-05-10', size: '3.4MB'),
  DocumentFile(name: '総会議事録.pdf', date: '2026-06-01', size: '850KB'),
];

class SurveyItem {
  final String title;
  final String url;
  final String date;
  const SurveyItem({required this.title, required this.url, required this.date});
}

const List<SurveyItem> surveyItems = [
  SurveyItem(title: '夏祭りに関するアンケート', url: 'https://forms.gle/example1', date: '2026-06-10'),
  SurveyItem(title: '町内会運営に関するご意見募集', url: 'https://forms.gle/example2', date: '2026-05-01'),
];
