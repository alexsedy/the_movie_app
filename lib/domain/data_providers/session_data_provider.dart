import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SessionDataProvider{
  static const _secureStorage = FlutterSecureStorage();

  static Future<String?> getSessionId() => _secureStorage.read(key: _Keys.sessionId);
  static Future<void> setSessionId(String? value) {
    if(value != null) {
      return _secureStorage.write(key: _Keys.sessionId, value: value);
    } else {
      return _secureStorage.delete(key: _Keys.sessionId);
    }
  }

  static Future<String?> getAccessToken() => _secureStorage.read(key: _Keys.accessToken);
  static Future<void> setAccessToken(String? value) {
    if(value != null) {
      return _secureStorage.write(key: _Keys.accessToken, value: value);
    } else {
      return _secureStorage.delete(key: _Keys.accessToken);
    }
  }
}

abstract class _Keys{
  static const sessionId = "session_id";
  static const accessToken = "access_token";
}