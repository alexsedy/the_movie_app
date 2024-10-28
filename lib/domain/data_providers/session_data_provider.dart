import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionDataProvider{
  static const _secureStorage = FlutterSecureStorage();

  Future<String?> getSessionId() => _secureStorage.read(key: _Keys.sessionId);
  Future<void> setSessionId(String? value) {
    if(value != null) {
      return _secureStorage.write(key: _Keys.sessionId, value: value);
    } else {
      return _secureStorage.delete(key: _Keys.sessionId);
    }
  }

  Future<String?> getAccessToken() => _secureStorage.read(key: _Keys.accessToken);
  Future<void> setAccessToken(String? value) {
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