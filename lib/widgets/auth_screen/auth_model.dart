import 'dart:io';

import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/domain/api_client/auth_api_client.dart';
import 'package:the_movie_app/domain/data_providers/session_data_provider.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class AuthModel extends ChangeNotifier {
  final _apiClient = AuthApiClient();
  final _sessionDataProvider = SessionDataProvider();
  final usernameTextController = TextEditingController(text: "alexsedy");
  //alexsedy
  final passwordTextController = TextEditingController(text: "Rk!4C7fMtb3GKWr");
  //Rk!4C7fMtb3GKWr

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;

  Future<void> auth(BuildContext context) async{
    final username = usernameTextController.text;
    final password = passwordTextController.text;

    if(username.isEmpty || password.isEmpty) {
      _errorMessage = "Please enter Username and Password";
      notifyListeners();
      return;
    }
    _errorMessage = null;
    _isAuthProgress = true;
    notifyListeners();

    String? sessionId;
    try {
      sessionId = await _apiClient.auth(username: username, password: password);
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.network:
          _errorMessage = "Server is not available. Please check the connection or try again later.";
          break;
        case ApiClientExceptionType.auth:
          _errorMessage = "Invalid Username and/or Password";
          break;
        case ApiClientExceptionType.other:
          _errorMessage = "An error has occurred. Try again.";
          break;
        default:
          break;
      }
    } on SocketException catch (_) {
      _errorMessage = "Server is not available. Please check the connection or try again later.";
    } catch (e) {
      _errorMessage = "An error has occurred. Please ry again.";
    }

    _isAuthProgress = false;

    if(_errorMessage != null) {
      notifyListeners();
      return;
    }

    if(sessionId == null) {
      _errorMessage = "Unknown error, please try again";
      notifyListeners();
      return;
    }
    await _sessionDataProvider.setSessionId(sessionId);
    Navigator.of(context).pushNamedAndRemoveUntil(MainNavigationRouteNames.mainScreen, (route) => false,);
  }
}
