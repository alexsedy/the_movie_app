import 'package:flutter/material.dart';

abstract class AppSpacing {
  static const double p2 = 2.0;
  static const double p4 = 4.0;
  static const double p6 = 6.0;
  static const double p10 = 10.0;
  static const double p12 = 12.0;
  static const double p16 = 16.0;
  static const double p20 = 20.0;
  static const double p32 = 32.0;
  static const double p40 = 40.0;
  static const double p56 = 56.0;
  static const double p60 = 60.0;
  static const double p80 = 80.0;
  static const double p130 = 130.0;
  static const double p160 = 160.0;
  static const double p216 = 216.0;


  static const EdgeInsets screenPaddingAll6 = EdgeInsets.all(p6);
  static const EdgeInsets screenPaddingAll10 = EdgeInsets.all(p10);
  static const EdgeInsets screenPaddingH10V4 = EdgeInsets.symmetric(horizontal: p10, vertical: p4);
  static const EdgeInsets screenPaddingH10V20 = EdgeInsets.symmetric(horizontal: p10, vertical: p20);
  static const EdgeInsets screenPaddingH16V10 = EdgeInsets.symmetric(horizontal: p16, vertical: p10);
  static const EdgeInsets screenPaddingH60V16 = EdgeInsets.symmetric(horizontal: p60, vertical: p16);
  static const EdgeInsets screenPaddingH10 = EdgeInsets.symmetric(horizontal: p10);
  static const EdgeInsets screenPaddingMedia = EdgeInsets.only(top: p6, left: p10, right: p10, bottom: p2);
  static const EdgeInsets screenPaddingL16R10B2 = EdgeInsets.only(left: p16, right: p10, bottom: p2);
  static const EdgeInsets screenPaddingL56 = EdgeInsets.only(left: p56,);


  static const Widget gapH6 = SizedBox(height: p6);
  static const Widget gapH10 = SizedBox(height: p10);
  static const Widget gapH12 = SizedBox(height: p12);
  static const Widget gapH16 = SizedBox(height: p16);
  static const Widget gapH20 = SizedBox(height: p20);
  static const Widget gapH32 = SizedBox(height: p32);
  static const Widget gapH40 = SizedBox(height: p40);
  static const Widget gapH80 = SizedBox(height: p80);

  static const Widget gapW10 = SizedBox(width: p10);
  static const Widget gapW16 = SizedBox(width: p16);
  static const Widget gapW20 = SizedBox(width: p20);
  static const Widget gapW160 = SizedBox(width: p160);

  static const Widget emptyGap = SizedBox.shrink();
}
