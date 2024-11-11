import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:the_movie_app/domain/api_client/search_api_client.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class AiRecommendationListModel extends ChangeNotifier{
  List<MediaList> listResponse = [];
  final String prompt;
  final bool isMovie;
  final _apiClient = SearchApiClient();
  static const _apiKey = "AIzaSyBQoaxE_7G6m_xJz_d88CkGx8_n4NBi1Q4";
  final _model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: _apiKey,
  );


  AiRecommendationListModel({required this.prompt, required this.isMovie});

  Stream<List<MediaList>> generateAndGetMovies() async* {
    final response = await _model.generateContent([Content.text(prompt)]);
    final text = await response.text;

    List<MediaList> listResponse = [];
    List<String> list = [];

    if(text != null) {
      list = text.split(";");
    }

    for(var movie in list) {
      movie = movie.trim();
      // .replaceAll("\n", "");

      if(isMovie) {
        final response = await _apiClient.getSearchMovies(
            query: movie, page: 1);
        listResponse.add(response.list.first);
      } else {
        final response = await _apiClient.getSearchTvs(
            query: movie, page: 1);
        listResponse.add(response.list.first);
      }

      yield listResponse;
    }
  }

  void onMovieScreen(BuildContext context, int id) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  void onTvShowScreen(BuildContext context, int id) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.tvShowDetails, arguments: id);
  }
}