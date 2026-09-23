import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' as io;

/// APIサーバーのベースURL。
/// - iOSシミュレータ・Web・デスクトップ：ホストマシンのlocalhostがそのまま見える
/// - Android実機/エミュレータ：エミュレータから見たホストは 10.0.2.2
class ApiConfig {
  ApiConfig._();

  static const int port = 8099;

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:$port/v1';
    }
    if (io.Platform.isAndroid) {
      return 'http://10.0.2.2:$port/v1';
    }
    return 'http://localhost:$port/v1';
  }
}
