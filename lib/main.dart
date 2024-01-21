import 'package:flutter/material.dart';
import 'package:the_movie_app/widgets/login_screen/login_widget.dart';
import 'package:the_movie_app/widgets/main_screen/main_screen_widget.dart';
import 'package:the_movie_app/widgets/movie_details_screen/movie_details_widget.dart';
import 'package:the_movie_app/widgets/theme/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Movie',
      theme: ThemeData(appBarTheme: const AppBarTheme(backgroundColor: AppColors.mainBlue),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.mainBlue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
      ),
      //theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //useMaterial3: true,
      ),
      routes: {
        "/auth" : (context) => AuthWidget(), //AuthWidget(),
        "/main_screen" : (context) => MainScreenWidget(),
        "/main_screen/movie_details" : (context)  {
          // final id = ModalRoute.of(context)!.settings.arguments as int;
          // return MovieDetailsWidget(movieId: id,);
          final arguments = ModalRoute.of(context)?.settings.arguments;
          if (arguments is int) {
            return MovieDetailsWidget(movieId: arguments,);
          } else {
            return MovieDetailsWidget(movieId: 0,); //todo экран с ошибкой
          }
        },
      },
      initialRoute: '/auth',
    );
  }
}