import 'package:the_movie_app/data/datasources/remote/api_client/search_api_client.dart';
import 'package:the_movie_app/data/models/media/list/list.dart';
import 'package:the_movie_app/data/models/media/media_collections/media_collections.dart';
import 'package:the_movie_app/data/models/person/trending_person/trending_person.dart';
import 'package:the_movie_app/data/repositories/i_search_repository.dart';

class SearchRepositoryImpl implements ISearchRepository {
  final SearchApiClient _apiClient;

  SearchRepositoryImpl(this._apiClient);

  @override
  Future<CollectionsList> getSearchMediaCollections({required String query, required int page}) =>
      _apiClient.getSearchMediaCollections(query: query, page: page);

  @override
  Future<MediaListResponse> getSearchMovies({required String query, required int page}) =>
      _apiClient.getSearchMovies(query: query, page: page);

  @override
  Future<MediaListResponse> getSearchTvs({required String query, required int page}) =>
      _apiClient.getSearchTvs(query: query, page: page);

  @override
  Future<TrendingPerson> getSearchPersons({required String query, required int page}) =>
      _apiClient.getSearchPersons(query: query, page: page);

  @override
  Future<MediaListResponse> getSearchMulti({required String query, required int page}) =>
      _apiClient.getSearchMulti(query: query, page: page);
}