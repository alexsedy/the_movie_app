import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:the_movie_app/l10n/generated/l10n.dart';
import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';
import 'package:the_movie_app/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  static final mainNavigation = MainNavigation();
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Movie',
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("en", "US"),
        Locale("en", "UA"),
        Locale("uk", "UA"),
        Locale("uk", "US"),
        Locale("ru", "UA"),
        Locale("ru", "US"),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // final userLocale = model?.locale;
        // if (userLocale != null) {
        //   return userLocale;
        // }
        //
        // for (var supportedLocale in supportedLocales) {
        //   if (supportedLocale.languageCode == locale?.languageCode
        //       && supportedLocale.countryCode == locale?.countryCode) {
        //     model?.setCurrentLocale(supportedLocale);
        //     return supportedLocale;
        //   }
        // }

        const defaultLocale = Locale('en', 'US');
        return defaultLocale;
      },
      routes: mainNavigation.routes,
      onGenerateRoute: mainNavigation.onGenerateRoute,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}