import 'package:flutter/material.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class AiRecommendationModel extends ChangeNotifier {
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
    // var prompt = '''
    //   Предоставь список из $count фильмов в жанре $_genres в формате,
    //   где указаны только названия фильмов через символ ";". Без номеров, точек,
    //   маркеров или дополнительных символов. Только названия подряд.
    //   Пожалуйста, выбери разнообразные фильмы, как классику, так и современные картины.
    // ''';
    if(isMovie) {
      prompt = '''
        Provide a list of $count movies in the $_genres genre in the format 
        where only movie titles are listed, separated by ";". No numbers, periods,
        bullets, or additional characters. Just the titles in a row.
        Please select a variety of movies, both classics and modern films.
        ''';
    } else {
      prompt = '''
        Provide a list of $count TV shows in the $_genres genre in the format 
        where only TV shows titles are listed, separated by ";". No numbers, periods,
        bullets, or additional characters. Just the titles in a row.
        Please select a variety of movies, both classics and modern films.
        ''';
    }
    Navigator.pushNamed(
        context,
        MainNavigationRouteNames.aiRecommendationList,
        arguments: {"prompt": prompt, "isMovie": isMovie});
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