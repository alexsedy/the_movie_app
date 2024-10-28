import 'package:flutter/material.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/my_app/my_app.dart';
import 'package:the_movie_app/widgets/my_app/my_app_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final model = MyAppModel();

  const app = MyApp();
  final widgetApp = Provider(model: model, child: app);

  runApp(widgetApp);
}