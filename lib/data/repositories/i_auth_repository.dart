import 'package:the_movie_app/data/models/auth/auth.dart';

abstract class IAuthRepository {
  Future<String> createRequestToken();
  Future<AuthData> createAccessToken({required String requestToken});
  Future<String> createSession(String accessToken);
  Future<void> deleteSession();
  Future<void> logout();
}