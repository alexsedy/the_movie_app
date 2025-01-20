import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

abstract class SnackBarHelper{
   static Future<void> handleErrorForUserLists({required Function apiReq, required BuildContext context}) async {
    try {
      await apiReq();
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.sessionExpired:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 5),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.l10n.youAreNotLoggedIn, style: const TextStyle(fontSize: 20),),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.mainScreen, arguments: 3),
                  child: Text(context.l10n.login),
                )
              ],
            ),
          ));
          Navigator.of(context).pop();

        case ApiClientExceptionType.notFound:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 5),
            content: Text(
              context.l10n.anErrorHasOccurredTryAgainLater,
              style: const TextStyle(fontSize: 20),),
          ));

          Navigator.of(context).pop();
        default:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 5),
            content: Text(
              context.l10n.anErrorHasOccurredTryAgainLater,
              style: const TextStyle(fontSize: 20),),
          ));
      }
    }
  }

  static Future<void> handleErrorWithMessage({required Function apiReq,
    required BuildContext context, required MessageType messageType,
    String message = ""}) async {
    try {
      await apiReq();

      switch (messageType) {
        case MessageType.listCreated:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 5),
            content: Text(
              context.l10n.listCreatedMessage(message),
              style: TextStyle(fontSize: 20),),
          ));
          Navigator.of(context).pop();
          return;

        case MessageType.movieAddedToList:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 5),
            content: Text(
              context.l10n.movieAddedToListMessage(message),
              style: TextStyle(fontSize: 20),),
          ));
          Navigator.of(context).pop();
          return;

        case MessageType.tvShowAddedToList:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 5),
            content: Text(
              context.l10n.tvAddedToListMessage(message),
              style: TextStyle(fontSize: 20),),
          ));
          Navigator.of(context).pop();
          return;

        case MessageType.remove:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 5),
            content: Text(
              context.l10n.theListRemovedMessage,
              style: TextStyle(fontSize: 20),),
          ));
          Navigator.of(context).pop();
          return;

        default:
      }

    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.sessionExpired:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 5),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.youAreNotLoggedIn,
                  style: const TextStyle(fontSize: 20),),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed(MainNavigationRouteNames.mainScreen, arguments: 3),
                  child: Text(context.l10n.login),
                )
              ],
            ),
          ));
        default:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 5),
            content: Text(
              context.l10n.anErrorHasOccurredTryAgainLater,
              style: const TextStyle(fontSize: 20),),
          ));
      }
    }
  }
}

enum MessageType {
  listCreated, movieAddedToList, tvShowAddedToList, favorite, watch, rate, remove
}