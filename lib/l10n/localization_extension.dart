import 'package:flutter/material.dart';
import 'package:the_movie_app/l10n/generated/l10n.dart';

extension LocalizationExtension on BuildContext {
  S get l10n => S.of(this);
}