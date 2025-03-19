import 'package:flutter/material.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

abstract class SnackBarMessageHandler {
  static void showSuccessSnackBar({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 5),
      content: Text(message, style: TextStyle(fontSize: 20),),
    ));
  }

  static void showErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 5),
      content: Text(
        context.l10n.anErrorHasOccurredTryAgainLater,
        style: const TextStyle(fontSize: 20),
      ),
    ));
  }

  static void showSuccessSnackBarWithPop({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 5),
      content: Text(message, style: TextStyle(fontSize: 20),),
    ));
    Navigator.pop(context);
  }

  static void showErrorSnackBarWithPop(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 5),
      content: Text(
        context.l10n.anErrorHasOccurredTryAgainLater,
        style: const TextStyle(fontSize: 20),
      ),
    ));
    Navigator.pop(context);
  }

  static void showErrorSnackBarWithLoginButton(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 5),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(context.l10n.youAreNotLoggedIn, style: const TextStyle(fontSize: 20),),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pushNamed(MainNavigationRouteNames.mainScreen, arguments: 3),
            child: Text(context.l10n.login),
          )
        ],
      ),
    ));
  }
}