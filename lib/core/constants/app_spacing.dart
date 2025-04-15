import 'package:flutter/material.dart';

abstract class AppSpacing {
  static const double p4 = 4.0;
  static const double p8 = 8.0;
  static const double p12 = 12.0;
  static const double p16 = 16.0;
  static const double p20 = 20.0;
  static const double p24 = 24.0;
  static const double p32 = 32.0;
  static const double p48 = 48.0;
  static const double p64 = 64.0;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: p16, vertical: p24);

  static const Widget gapW4 = SizedBox(width: p4);
  static const Widget gapW8 = SizedBox(width: p8);
  static const Widget gapW12 = SizedBox(width: p12);
  static const Widget gapW16 = SizedBox(width: p16);
  static const Widget gapW24 = SizedBox(width: p24);
  static const Widget gapW32 = SizedBox(width: p32);

  static const Widget gapH4 = SizedBox(height: p4);
  static const Widget gapH8 = SizedBox(height: p8);
  static const Widget gapH12 = SizedBox(height: p12);
  static const Widget gapH16 = SizedBox(height: p16);
  static const Widget gapH24 = SizedBox(height: p24);
  static const Widget gapH32 = SizedBox(height: p32);
  static const Widget gapH48 = SizedBox(height: p48);
  static const Widget gapH64 = SizedBox(height: p64);
}
