import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/my_app/my_app_model.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class MyApp extends StatelessWidget {
  static final mainNavigation = MainNavigation();
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final model = Provider.read<MyAppModel>(context);

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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', "US"),
        Locale('ru', "RU"),
        Locale("uk", "UA")
      ],
      routes: mainNavigation.routes,
      onGenerateRoute: mainNavigation.onGenerateRoute,
    );
  }
}