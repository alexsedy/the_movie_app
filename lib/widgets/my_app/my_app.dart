import 'package:flutter/material.dart';
import 'package:the_movie_app/widgets/my_app/my_app_model.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class MyApp extends StatelessWidget {
  final MyAppModel model;
  static final mainNavigation = MainNavigation();
  const MyApp({super.key, required this.model});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Movie',
      // theme: ThemeData(
      //   appBarTheme: const AppBarTheme(backgroundColor: AppColors.mainBlue),
      //   bottomNavigationBarTheme: BottomNavigationBarThemeData(
      //     backgroundColor: AppColors.mainBlue,
      //     selectedItemColor: Colors.white,
      //     unselectedItemColor: Colors.grey,
      //   ),
      // ),
      routes: mainNavigation.routes,
      initialRoute: mainNavigation.initialRouts(model.isAuth),
      onGenerateRoute: mainNavigation.onGenerateRoute,
    );
  }
}