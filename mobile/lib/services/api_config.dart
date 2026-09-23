import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' as io;

/// APIサーバーのベースURL。
/// - iOSシミュレータ・Web・デスクトップ：ホストマシンのlocalhostがそのまま見える
/// - Android実機/エミュレータ：エミュレータから見たホストは 10.0.2.2
class ApiConfig {
  ApiConfig._();

  static const int port = 8099;

  static String get _host {
    if (!kIsWeb && io.Platform.isAndroid) {
      return '10.0.2.2';
    }
    return 'localhost';
  }

  /// JSON API（/v1/...）のベースURL。
  static String get baseUrl => 'http://$_host:$port/v1';

  /// 管理者側でアップロードされた画像・資料の配信元（api/uploads/ を静的配信）。
  /// 例: '$mediaBaseUrl/uploads/circulars/xxxx.jpg'
  static String get mediaBaseUrl => 'http://$_host:$port';
}
