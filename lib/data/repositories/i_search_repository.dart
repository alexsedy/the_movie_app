import 'package:the_movie_app/data/models/media/list/list.dart';
import 'package:the_movie_app/data/models/media/media_collections/media_collections.dart';
import 'package:the_movie_app/data/models/person/trending_person/trending_person.dart';

abstract class ISearchRepository {
  Future<CollectionsList> getSearchMediaCollections({required String query, required int page});
  Future<MediaListResponse> getSearchMovies({required String query, required int page});
  Future<MediaListResponse> getSearchTvs({required String query, required int page});
  Future<TrendingPerson> getSearchPersons({required String query, required int page});
  Future<MediaListResponse> getSearchMulti({required String query, required int page});
}