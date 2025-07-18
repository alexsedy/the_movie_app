import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:the_movie_app/core/helpers/api_error_mapper.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/data/models/media/list/list.dart';
import 'package:the_movie_app/data/repositories/i_search_repository.dart';
import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';

enum AiListType{
  genre, description
}

class AiRecommendationListViewModel extends ChangeNotifier {
  final String prompt;
  final bool isMovie;
  final AiListType aiListType;
  final ISearchRepository _searchRepository;
  final GenerativeModel _generativeModel;
  String? _errorMessage;

  final _recommendationsController = StreamController<List<MediaList>>.broadcast();
  final List<MediaList> _currentRecommendations = [];

  Stream<List<MediaList>> get recommendationsStream => _recommendationsController.stream;
  String? get errorMessage  => _errorMessage;

  AiRecommendationListViewModel({
    required this.prompt,
    required this.isMovie,
    required this.aiListType,
    required ISearchRepository searchRepository,
    required GenerativeModel generativeModel,
  }) : _searchRepository = searchRepository,
        _generativeModel = generativeModel {
    generateAndFetch();
  }



  Future<void> generateAndFetch() async {
    _recommendationsController.add([]);

    try {
      final response = await _generativeModel.generateContent([Content.text(prompt)]);
      final text = response.text;

      if (text == null || text.trim().isEmpty) {
        throw Exception("Gemini returned empty response.");
      }

      final titles = text.split(';').map((t) => t.trim().replaceAll("\n", "")).where((t) => t.isNotEmpty).toList();

      if (titles.isEmpty) {
        _recommendationsController.add([]);
        return;
      }

      _errorMessage = null;
      notifyListeners();

      for (final title in titles) {
        try {
          MediaListResponse searchResult;

          switch(aiListType) {
            case AiListType.genre:
              if (isMovie) {
                searchResult = await _searchRepository.getSearchMovies(query: title, page: 1);
              } else {
                searchResult = await _searchRepository.getSearchTvs(query: title, page: 1);
              }

            case AiListType.description:
              searchResult = await _searchRepository.getSearchMulti(query: title, page: 1);
          }
          if (searchResult.list.isNotEmpty) {
            _currentRecommendations.add(searchResult.list.first);
            _recommendationsController.add(List.from(_currentRecommendations));
          }

          _errorMessage = null;
        } catch (e) {
          print("Error searching for '$title': $e");
          if(e is ApiClientException) {
            _errorMessage = ApiErrorMapper.mapError(e);
          } else {
            _errorMessage = ApiErrorMapper.unknownError();
          }
        }
      }
      if (_currentRecommendations.isEmpty) {
        _recommendationsController.add([]);
      }

    } catch (e) {
      print("Error generating or fetching recommendations: $e");
      _errorMessage = ApiErrorMapper.unknownError();
    } finally {
      notifyListeners();
    }
  }

  void onMovieScreen(BuildContext context, int id) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  void onTvShowScreen(BuildContext context, int id) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.tvShowDetails, arguments: id);
  }

  void onMediaScreen(BuildContext context, int id, String mediaType) {
    if (mediaType == "movie") {
      onMovieScreen(context, id);
    } else if (mediaType == "tv") {
      onTvShowScreen(context, id);
    }
  }

  @override
  void dispose() {
    _recommendationsController.close();
    super.dispose();
  }
}
