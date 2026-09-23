import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// api/README.md の {"data":..., "error":...} 形式を模したスタブAPIサーバー。
/// テストごとに呼び出し、ApiClient.client に差し替えて使う。
http.Client buildMockApiClient() {
  final wholeChatMessages = <Map<String, dynamic>>[
    {
      'id': 1,
      'sender_is_admin': true,
      'sender_member_id': null,
      'sender_name': null,
      'body': '来週の町内清掃活動は9/27（日）朝8時からです。',
      'created_at': '2026-09-20 10:02:00',
    },
  ];

  http.Response ok(dynamic data, {int status = 200}) {
    return http.Response(
      jsonEncode({'data': data, 'error': null}),
      status,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }

  http.Response notFound(String path) {
    return http.Response(
      jsonEncode({
        'data': null,
        'error': {'code': 'NOT_MOCKED', 'message': 'テストでスタブされていないエンドポイントです: $path'},
      }),
      404,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }

  return MockClient((request) async {
    final path = request.url.path;
    final method = request.method;

    if (path == '/v1/auth/login.php' && method == 'POST') {
      return ok({
        'token': 'test-token',
        'member': {'id': 2, 'name': '鈴木 花子', 'group_id': 2, 'role': 'none'},
      }, status: 201);
    }

    if (path == '/v1/groups.php' && method == 'GET') {
      return ok([
        {'id': 1, 'name': '1組'},
        {'id': 2, 'name': '2組'},
        {'id': 3, 'name': '3組'},
      ]);
    }

    if (path == '/v1/notices.php' && method == 'GET') {
      return ok([
        {
          'id': 1,
          'title': '夏祭りのお知らせ',
          'body': '出店や盆踊りを予定しています。',
          'published_at': '2026-07-01',
        },
      ]);
    }

    if (path == '/v1/schedules.php' && method == 'GET') {
      return ok(<Map<String, dynamic>>[]);
    }

    if (path == '/v1/circulars.php' && method == 'GET') {
      return ok([
        {
          'id': 1,
          'title': '自治会費集金のお知らせ',
          'body': '7月分の自治会費集金を行います。',
          'image_path': null,
          'start_date': '2026-07-01',
          'end_date': '2026-07-31',
          'is_read': false,
        },
      ]);
    }

    if (path == '/v1/circular_read.php' && method == 'POST') {
      return ok({'read': true});
    }

    if (path == '/v1/chat_all.php' && method == 'GET') {
      return ok(List<Map<String, dynamic>>.from(wholeChatMessages));
    }

    if (path == '/v1/chat_all.php' && method == 'POST') {
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      wholeChatMessages.add({
        'id': wholeChatMessages.length + 1,
        'sender_is_admin': false,
        'sender_member_id': 2,
        'sender_name': '鈴木 花子',
        'body': body['body'],
        'created_at': '2026-09-22 12:00:00',
      });
      return ok({'id': wholeChatMessages.length}, status: 201);
    }

    if (path == '/v1/chat_leader.php' && method == 'GET') {
      return ok(<Map<String, dynamic>>[]);
    }

    if (path == '/v1/garbage_duties.php' && method == 'GET') {
      return ok(<Map<String, dynamic>>[]);
    }

    if (path == '/v1/surveys.php' && method == 'GET') {
      return ok(<Map<String, dynamic>>[]);
    }

    if (path == '/v1/documents.php' && method == 'GET') {
      return ok(<Map<String, dynamic>>[]);
    }

    return notFound(path);
  });
}
