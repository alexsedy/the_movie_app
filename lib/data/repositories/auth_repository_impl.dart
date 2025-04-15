import 'package:the_movie_app/data/datasources/remote/api_client/auth_api_client.dart';
import 'package:the_movie_app/data/models/auth/auth.dart';
import 'package:the_movie_app/data/repositories/i_auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthApiClient _apiClient;

  AuthRepositoryImpl(this._apiClient);

  @override
  Future<String> createRequestToken() => _apiClient.createRequestToken();

  @override
  Future<AuthData> createAccessToken({required String requestToken}) =>
      _apiClient.createAccessToken(requestToken: requestToken);

  @override
  Future<String> createSession(String accessToken) => _apiClient.createSession(accessToken);

  @override
  Future<void> deleteSession() => _apiClient.deleteSession();

  @override
  Future<void> logout() => _apiClient.logout();
}