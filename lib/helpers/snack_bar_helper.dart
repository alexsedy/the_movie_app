import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

abstract class SnackBarHelper{
  static Future<bool> handleError({required Function apiReq, required BuildContext context}) async {
    try {
      await apiReq();
      return true;
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.sessionExpired:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 5),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("You are not logged in.", style: TextStyle(fontSize: 20),),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed(MainNavigationRouteNames.mainScreen, arguments: 3),
                  child: const Text("Login"),
                )
              ],
            ),
          ));
         return false;
        default:
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 5),
            content: Text("An error has occurred. Try again.", style: TextStyle(fontSize: 20),),
          ));
          return false;
      }
    }
  }
}