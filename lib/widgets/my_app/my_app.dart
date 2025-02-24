import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:the_movie_app/l10n/generated/l10n.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/my_app/my_app_model.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class MyApp extends StatelessWidget {
  static final mainNavigation = MainNavigation();
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.watch<MyAppModel>(context);

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

        const defaultLocale = Locale('ru', 'US');
        model?.setCurrentLocale(defaultLocale);
        return defaultLocale;
      },
      routes: mainNavigation.routes,
      onGenerateRoute: mainNavigation.onGenerateRoute,
    );
  }
}