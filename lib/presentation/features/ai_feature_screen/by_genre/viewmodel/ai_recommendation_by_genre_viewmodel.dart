import 'package:flutter/material.dart';
import 'package:the_movie_app/core/constants/navigator_param_const.dart';
import 'package:the_movie_app/data/datasources/local/cache_management/account_management.dart';
import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';

class AiRecommendationByGenreViewModel extends ChangeNotifier {
  String? _genres;
  bool _isReadyToGenerate = false;
  final _movieGenreActions = <String, bool>{
    'Action': false, 'Adventure': false, 'Animation': false, 'Comedy': false,
    'Crime': false, 'Documentary': false, 'Drama': false, 'Family': false,
    'Fantasy': false, 'History': false, 'Horror': false, 'Music': false,
    'Mystery': false, 'Romance': false, 'Science Fiction': false,
    'TV Movie': false, 'Thriller': false, 'War': false, 'Western': false,
  };
  final _tvGenreActions = <String, bool>{
    'Action & Adventure': false, 'Animation': false, 'Comedy': false,
    'Crime': false, 'Documentary': false, 'Drama': false, 'Family': false,
    'Kids': false, 'Mystery': false, 'News': false, 'Reality': false,
    'Sci-Fi & Fantasy': false, 'Soap': false, 'Talk': false,
    'War & Politics': false, 'Western': false,
  };

  Map<String, bool> get movieGenreActions => _movieGenreActions;
  Map<String, bool> get tvGenreActions => _tvGenreActions;
  bool get isReadyToGenerate => _isReadyToGenerate;

  void toggleMovieGenre(String genre) {
    if (_movieGenreActions.containsKey(genre)) {
      _movieGenreActions[genre] = !_movieGenreActions[genre]!;
      _updateReadyState(_movieGenreActions);
      notifyListeners();
    }
  }

  void toggleTvGenre(String genre) {
    if (_tvGenreActions.containsKey(genre)) {
      _tvGenreActions[genre] = !_tvGenreActions[genre]!;
      _updateReadyState(_tvGenreActions);
      notifyListeners();
    }
  }

  void _updateReadyState(Map<String, bool> actions) {
    _isReadyToGenerate = actions.values.any((isSelected) => isSelected);
  }

  void resetGenre(bool isMovie) {
    _isReadyToGenerate = false;
    final actions = isMovie ? _movieGenreActions : _tvGenreActions;
    actions.updateAll((key, value) => false);
    notifyListeners();
  }

  void _prepareSelectedGenres(bool isMovie) {
    final selectedGenres = <String>[];
    final actions = isMovie ? _movieGenreActions : _tvGenreActions;
    actions.forEach((key, value) {
      if (value) {
        selectedGenres.add(key);
      }
    });
    _genres = selectedGenres.isEmpty ? null : selectedGenres.join(',');
  }

  Future<void> onGenerateContent(BuildContext context, int count, bool isMovie) async {
    _prepareSelectedGenres(isMovie);
    if (_genres == null) return;

    String prompt = await _buildPrompt(count, isMovie, _genres!);

    Navigator.pushNamed(
        context,
        MainNavigationRouteNames.aiRecommendationList,
        arguments: {
          NavParamConst.prompt: prompt,
          NavParamConst.isMovie: true,
          NavParamConst.isGenre: false,
        }
    );
  }

  Future<String> _buildPrompt(int count, bool isMovie, String genres) async {
    String prompt;
    Locale? locale = await AccountManager.getUserLocale();
    String langCode = locale?.languageCode ?? 'en'; // Default to English

    // TODO: Локализовать шаблоны промптов
    final moviePromptTemplate = {
      'en': '''
              Return exactly $count movie titles (including films, animated movies, or anime movies) in the $genres genre(s).
              Format: Title1; Title2; Title3
              Rules: - Only titles, separated by semicolons - No numbering or explanations - Only complete, self-contained movies (not TV series) - Include both classic and modern titles
              Important: Respond ONLY with the titles, nothing else.
            ''',
      'uk': '''
              Надайте рівно $count назв фільмів (включаючи кінофільми, мультфільми або повнометражне аніме) у жанрі(ах) $genres.
              Формат: Назва1; Назва2; Назва3
              Правила: - Тільки назви, розділені крапкою з комою - Без нумерації та пояснень - Тільки повнометражні фільми (не серіали) - Включіть як класику, так і сучасні роботи
              Важливо: Відповідь ТІЛЬКИ назвами, нічого додаткового.
            ''',
      'ru': '''
              Предоставьте ровно $count названий фильмов (включая кинофильмы, мультфильмы или полнометражное аниме) в жанре(ах) $genres.
              Формат: Название1; Название2; Название3
              Правила: - Только названия, разделённые точкой с запятой - Без нумерации и пояснений - Только полнометражные фильмы (не сериалы) - Включите как классику, так и современные работы
              Важно: Ответ ТОЛЬКО названиями, ничего дополнительного.
            '''
    };
    final tvPromptTemplate = {
      'en': '''
              Return exactly $count TV series titles (including TV shows, animated series, or anime series) in the $genres genre(s).
              Format: Title1; Title2; Title3
              Rules: - Only titles, separated by semicolons - No numbering or explanations - Only series with multiple episodes (not single movies) - Include both classic and modern titles
              Important: Respond ONLY with the titles, nothing else.
            ''',
      'uk': '''
              Надайте рівно $count назв серіалів (включаючи телесеріали, мультсеріали або аніме-серіали) у жанрі(ах) $genres.
              Формат: Назва1; Назва2; Назва3
              Правила: - Тільки назви, розділені крапкою з комою - Без нумерації та пояснень - Тільки багатосерійні твори (не окремі фільми) - Включіть як класику, так і сучасні роботи
              Важливо: Відповідь ТІЛЬКИ назвами, нічого додаткового.
            ''',
      'ru': '''
              Предоставьте ровно $count названий сериалов (включая телесериалы, мультсериалы или аниме-сериалы) в жанре(ах) $genres.
              Формат: Название1; Название2; Название3
              Правила: - Только названия, разделённые точкой с запятой - Без нумерации и пояснений - Только многосерийные произведения (не отдельные фильмы) - Включите как классику, так и современные работы
              Важно: Ответ ТОЛЬКО названиями, ничего дополнительного.
            '''
    };

    if (isMovie) {
      prompt = moviePromptTemplate[langCode] ?? moviePromptTemplate['en']!;
    } else {
      prompt = tvPromptTemplate[langCode] ?? tvPromptTemplate['en']!;
    }
    return prompt;
  }
}