import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/cache_management/account_management.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class AiRecommendationByGenreModel extends ChangeNotifier {
  String? _genres;
  var _isReadyToGenerate = false;
  final _movieGenreActions = <String, bool>{
    'Action': false,
    'Adventure': false,
    'Animation': false,
    'Comedy': false,
    'Crime': false,
    'Documentary': false,
    'Drama': false,
    'Family': false,
    'Fantasy': false,
    'History': false,
    'Horror': false,
    'Music': false,
    'Mystery': false,
    'Romance': false,
    'Science Fiction': false,
    'TV Movie': false,
    'Thriller': false,
    'War': false,
    'Western': false,
  };
  final _tvGenreActions = <String, bool>{
   'Action & Adventure': false,
    'Animation': false,
   'Comedy': false,
    'Crime': false,
    'Documentary': false,
    'Drama': false,
    'Family': false,
    'Kids': false,
    'Mystery': false,
    'News': false,
    'Reality': false,
    'Sci-Fi & Fantasy': false,
    'Soap': false,
    'Talk': false,
    'War & Politics': false,
    'Western': false,
  };

  Map<String, bool> get movieGenreActions => _movieGenreActions;
  Map<String, bool> get tvGenreActions => _tvGenreActions;
  bool get isReadyToGenerate => _isReadyToGenerate;


  set isReadyToGenerate(value) {
    _isReadyToGenerate = value;
  }

  Future<void> onGenerateContent(BuildContext context, int count, bool isMovie) async {
    var prompt;
    _selectedGenres(isMovie);

    Locale? locale = await AccountManager.getUserLocale();
    if(locale != null) {
      switch(locale.languageCode){
        case "en":
          if(isMovie) {
            prompt = '''
              Return exactly $count movie titles (including films, animated movies, or anime movies) in the $_genres genre(s).
              Format: Title1; Title2; Title3
              Rules:
              - Only titles, separated by semicolons
              - No numbering or explanations
              - Only complete, self-contained movies (not TV series)
              - Include both classic and modern titles
              Important: Respond ONLY with the titles, nothing else.
            ''';
          } else {
            prompt = '''
              Return exactly $count TV series titles (including TV shows, animated series, or anime series) in the $_genres genre(s).
              Format: Title1; Title2; Title3
              Rules:
              - Only titles, separated by semicolons
              - No numbering or explanations
              - Only series with multiple episodes (not single movies)
              - Include both classic and modern titles
              Important: Respond ONLY with the titles, nothing else.
            ''';
          }
        case "uk":
          if(isMovie) {
            prompt = '''
              Надайте рівно $count назв фільмів (включаючи кінофільми, мультфільми або повнометражне аніме) у жанрі(ах) $_genres.
              Формат: Назва1; Назва2; Назва3
              Правила:
              - Тільки назви, розділені крапкою з комою
              - Без нумерації та пояснень
              - Тільки повнометражні фільми (не серіали)
              - Включіть як класику, так і сучасні роботи
              Важливо: Відповідь ТІЛЬКИ назвами, нічого додаткового.
            ''';
          } else {
            prompt = '''
              Надайте рівно $count назв серіалів (включаючи телесеріали, мультсеріали або аніме-серіали) у жанрі(ах) $_genres.
              Формат: Назва1; Назва2; Назва3
              Правила:
              - Тільки назви, розділені крапкою з комою
              - Без нумерації та пояснень
              - Тільки багатосерійні твори (не окремі фільми)
              - Включіть як класику, так і сучасні роботи
              Важливо: Відповідь ТІЛЬКИ назвами, нічого додаткового.
            ''';
          }
        case "ru":
          if(isMovie) {
            prompt = '''
              Предоставьте ровно $count названий фильмов (включая кинофильмы, мультфильмы или полнометражное аниме) в жанре(ах) $_genres.
              Формат: Название1; Название2; Название3
              Правила:
              - Только названия, разделённые точкой с запятой
              - Без нумерации и пояснений
              - Только полнометражные фильмы (не сериалы)
              - Включите как классику, так и современные работы
              Важно: Ответ ТОЛЬКО названиями, ничего дополнительного.
            ''';
          } else {
            prompt = '''
              Предоставьте ровно $count названий сериалов (включая телесериалы, мультсериалы или аниме-сериалы) в жанре(ах) $_genres.
              Формат: Название1; Название2; Название3
              Правила:
              - Только названия, разделённые точкой с запятой
              - Без нумерации и пояснений
              - Только многосерийные произведения (не отдельные фильмы)
              - Включите как классику, так и современные работы
              Важно: Ответ ТОЛЬКО названиями, ничего дополнительного.
            ''';
          }
        default:
          if(isMovie) {
            prompt = '''
              Return exactly $count movie titles (including films, animated movies, or anime movies) in the $_genres genre(s).
              Format: Title1; Title2; Title3
              Rules:
              - Only titles, separated by semicolons
              - No numbering or explanations
              - Only complete, self-contained movies (not TV series)
              - Include both classic and modern titles
              Important: Respond ONLY with the titles, nothing else.
            ''';
          } else {
            prompt = '''
              Return exactly $count TV series titles (including TV shows, animated series, or anime series) in the $_genres genre(s).
              Format: Title1; Title2; Title3
              Rules:
              - Only titles, separated by semicolons
              - No numbering or explanations
              - Only series with multiple episodes (not single movies)
              - Include both classic and modern titles
              Important: Respond ONLY with the titles, nothing else.
            ''';
          }
      }
    }

    // Для фильмов:
    // Предоставьте ровно $count названий фильмов (включая кинофильмы, мультфильмы или полнометражное аниме) в жанре(ах) $_genres.
    // Формат: Название1; Название2; Название3
    // Правила:
    // - Только названия, разделённые точкой с запятой
    // - Без нумерации и пояснений
    // - Только полнометражные фильмы (не сериалы)
    // - Включите как классику, так и современные работы
    // Важно: Ответ ТОЛЬКО названиями, ничего дополнительного.

// Для сериалов:
//     Предоставьте ровно $count названий сериалов (включая телесериалы, мультсериалы или аниме-сериалы) в жанре(ах) $_genres.
//     Формат: Название1; Название2; Название3
//     Правила:
//     - Только названия, разделённые точкой с запятой
//     - Без нумерации и пояснений
//     - Только многосерийные произведения (не отдельные фильмы)
//     - Включите как классику, так и современные работы
//     Важно: Ответ ТОЛЬКО названиями, ничего дополнительного.

    // Для фільмів:
    // Надайте рівно $count назв фільмів (включаючи кінофільми, мультфільми або повнометражне аніме) у жанрі(ах) $_genres.
    // Формат: Назва1; Назва2; Назва3
    // Правила:
    // - Тільки назви, розділені крапкою з комою
    // - Без нумерації та пояснень
    // - Тільки повнометражні фільми (не серіали)
    // - Включіть як класику, так і сучасні роботи
    // Важливо: Відповідь ТІЛЬКИ назвами, нічого додаткового.

// Для серіалів:
//     Надайте рівно $count назв серіалів (включаючи телесеріали, мультсеріали або аніме-серіали) у жанрі(ах) $_genres.
//     Формат: Назва1; Назва2; Назва3
//     Правила:
//     - Тільки назви, розділені крапкою з комою
//     - Без нумерації та пояснень
//     - Тільки багатосерійні твори (не окремі фільми)
//     - Включіть як класику, так і сучасні роботи
//     Важливо: Відповідь ТІЛЬКИ назвами, нічого додаткового.

    // if(isMovie) {
    //   prompt = '''
    //     Return exactly $count movie titles (including films, animated movies, or anime movies) in the $_genres genre(s).
    //     Format: Title1; Title2; Title3
    //     Rules:
    //     - Only titles, separated by semicolons
    //     - No numbering or explanations
    //     - Only complete, self-contained movies (not TV series)
    //     - Include both classic and modern titles
    //     Important: Respond ONLY with the titles, nothing else.
    //     ''';
    // } else {
    //   prompt = '''
    //     Return exactly $count TV series titles (including TV shows, animated series, or anime series) in the $_genres genre(s).
    //     Format: Title1; Title2; Title3
    //     Rules:
    //     - Only titles, separated by semicolons
    //     - No numbering or explanations
    //     - Only series with multiple episodes (not single movies)
    //     - Include both classic and modern titles
    //     Important: Respond ONLY with the titles, nothing else.
    //     ''';
    // }
    Navigator.pushNamed(
        context,
        MainNavigationRouteNames.aiRecommendationList,
        arguments: {"prompt": prompt, "isMovie": isMovie, "isGenre": true});
  }

  void _selectedGenres(bool isMovie) {
    final selectedGenres = <String>[];

    if(isMovie) {
      _movieGenreActions.forEach((key, value) {
        if (value) {
          selectedGenres.add(key);
        }
      });
    } else {
      _tvGenreActions.forEach((key, value) {
        if (value) {
          selectedGenres.add(key);
        }
      });
    }

    final result = selectedGenres.join(',');

    if(selectedGenres.isEmpty) {
      _genres = null;
    } else {
      _genres = result;
    }
  }

  void resetGenre(isMovie) {
    _isReadyToGenerate = false;
     isMovie
         ? movieGenreActions.updateAll((k, v) => false)
         :  tvGenreActions.updateAll((k, v) => false);
    notifyListeners();
  }
}