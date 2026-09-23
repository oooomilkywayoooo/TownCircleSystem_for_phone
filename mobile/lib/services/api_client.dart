import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'session.dart';

/// APIが返す {"error": {"code":..., "message":...}} をラップした例外。
class ApiException implements Exception {
  final String code;
  final String message;
  final int statusCode;
  ApiException(this.code, this.message, this.statusCode);

  @override
  String toString() => message;
}

/// api/README.md の {"data":..., "error":...} 形式のJSON APIを呼び出す薄いラッパー。
/// テスト時は ApiClient.client を http.testing.MockClient に差し替えることでスタブできる。
class ApiClient {
  ApiClient._();

  static http.Client client = http.Client();

  static Uri _uri(String path, [Map<String, String>? query]) {
    return Uri.parse('${ApiConfig.baseUrl}$path').replace(queryParameters: query);
  }

  static Map<String, String> _headers({bool withAuth = true}) {
    final headers = {'Content-Type': 'application/json'};
    if (withAuth && Session.instance.token != null) {
      headers['Authorization'] = 'Bearer ${Session.instance.token}';
    }
    return headers;
  }

  static dynamic _decode(http.Response response) {
    final Map<String, dynamic> json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['error'] != null) {
      final error = json['error'] as Map<String, dynamic>;
      throw ApiException(
        error['code'] as String? ?? 'UNKNOWN',
        error['message'] as String? ?? '通信エラーが発生しました',
        response.statusCode,
      );
    }
    return json['data'];
  }

  static Future<dynamic> get(String path, {Map<String, String>? query}) async {
    final response = await client.get(_uri(path, query), headers: _headers());
    return _decode(response);
  }

  static Future<dynamic> post(String path, {Object? body, Map<String, String>? query}) async {
    final response = await client.post(
      _uri(path, query),
      headers: _headers(),
      body: body != null ? jsonEncode(body) : null,
    );
    return _decode(response);
  }

  static Future<dynamic> put(String path, {Object? body}) async {
    final response = await client.put(
      _uri(path),
      headers: _headers(),
      body: body != null ? jsonEncode(body) : null,
    );
    return _decode(response);
  }
}
