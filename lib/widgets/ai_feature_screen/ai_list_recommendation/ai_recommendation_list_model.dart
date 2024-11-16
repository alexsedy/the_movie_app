import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:the_movie_app/domain/api_client/search_api_client.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class AiRecommendationListModel extends ChangeNotifier{
  List<MediaList> listResponse = [];
  final String prompt;
  final bool isMovie;
  final bool isGenre;
  final _apiClient = SearchApiClient();
  static const _apiKey = String.fromEnvironment('GEMINI_API_KEY');
  final _model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: _apiKey,
  );

  AiRecommendationListModel({required this.prompt, required this.isMovie, required this.isGenre,});

  Stream<List<MediaList>> generateAndGetContent() async* {
    final response = await _model.generateContent([Content.text(prompt)]);
    final text = await response.text;

    List<MediaList> listResponse = [];
    List<String> list = [];

    if(text != null) {
      list = text.split(";");
    }

    for(var item in list) {
      item = item.trim().replaceAll("\n", "");

      if(isMovie) {
        final response = await _apiClient.getSearchMovies(
            query: item, page: 1);
        if (response.list.isNotEmpty) {
          listResponse.add(response.list.first);
        }
      } else {
        final response = await _apiClient.getSearchTvs(
            query: item, page: 1);
        if (response.list.isNotEmpty) {
          listResponse.add(response.list.first);
        }
      }

      yield List.from(listResponse);
    }
  }

  Stream<List<MediaList>> generateAndGetContent2() async* {
    final response = await _model.generateContent([Content.text(prompt)]);
    final text = await response.text;

    List<MediaList> listResponse = [];
    List<String> list = [];

    if(text != null) {
      list = text.split(";");
    }

    for(var item in list) {
      item = item.trim().replaceAll("\n", "");


      final response = await _apiClient.getSearchMulti(
          query: item, page: 1);
      if (response.list.isNotEmpty) {
        listResponse.add(response.list.first);
      }

      yield List.from(listResponse);
    }
  }

  void onMovieScreen(BuildContext context, int id) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  void onTvShowScreen(BuildContext context, int id) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.tvShowDetails, arguments: id);
  }

  void onMediaScreen(BuildContext context, int id, String mediaType) {
    if(mediaType == "movie") {
      Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
    } else {
      Navigator.of(context).pushNamed(MainNavigationRouteNames.tvShowDetails, arguments: id);
    }
  }
}