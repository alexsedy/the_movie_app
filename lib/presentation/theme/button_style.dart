import 'package:flutter/material.dart';

abstract class AppButtonStyle{
  static final ButtonStyle linkButton = ButtonStyle(
    foregroundColor: MaterialStateProperty.all(Color(0xFF01B4E4)),
    textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16, fontWeight: FontWeight.w400))
  );

  static final ButtonStyle borderButton = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Color(0xFF01B4E4)),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      textStyle: MaterialStateProperty.all(
          TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)
      ),
      padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: 15, vertical: 8))
  );
}