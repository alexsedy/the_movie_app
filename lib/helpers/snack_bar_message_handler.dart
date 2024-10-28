import 'package:flutter/material.dart';

abstract class SnackBarMessageHandler {
  static void showSuccessSnackBar({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 5),
      content: Text(message, style: TextStyle(fontSize: 20),),
    ));
  }

  static void showErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 5),
      content: Text("An error has occurred. Try again.", style: TextStyle(fontSize: 20),),
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
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 5),
      content: Text("An error has occurred. Try again.", style: TextStyle(fontSize: 20),),
    ));
    Navigator.pop(context);
  }
}