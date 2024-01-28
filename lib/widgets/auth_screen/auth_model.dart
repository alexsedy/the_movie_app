import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/domain/data_providers/session_data_provider.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class AuthModel extends ChangeNotifier {
  final _apiClient = ApiClient();
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
    } catch (e) {
      _errorMessage = "Incorrect Username or Password";
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
    Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.mainScreen);
  }
}
