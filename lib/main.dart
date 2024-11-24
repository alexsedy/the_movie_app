import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:the_movie_app/firebase_options.dart';
import 'package:the_movie_app/l10n/generated/l10n.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/my_app/my_app.dart';
import 'package:the_movie_app/widgets/my_app/my_app_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  final model = MyAppModel();

  await model.getCurrentLocale();

  final locale = model.locale;
  if (locale != null) {
    await S.load(Locale(locale.languageCode));
  }

  const app = MyApp();
  final widgetApp = Provider(model: model, child: app);

  runApp(widgetApp);
}