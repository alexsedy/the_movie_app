import 'package:the_movie_app/data/datasources/remote/api_client/people_api_client.dart';
import 'package:the_movie_app/data/models/person/details/person_details.dart';
import 'package:the_movie_app/data/models/person/trending_person/trending_person.dart';
import 'package:the_movie_app/data/repositories/i_people_repository.dart';

class PeopleRepositoryImpl implements IPeopleRepository {
  final PeopleApiClient _apiClient;

  PeopleRepositoryImpl(this._apiClient);

  @override
  Future<PersonDetails> getPersonById(int personId) => _apiClient.getPersonById(personId);

  @override
  Future<TrendingPerson> getTrendingPerson({required int page, required String timeToggle}) =>
      _apiClient.getTrendingPerson(page: page, timeToggle: timeToggle);
}