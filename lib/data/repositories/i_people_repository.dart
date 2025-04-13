import 'package:the_movie_app/data/models/person/details/person_details.dart';
import 'package:the_movie_app/data/models/person/trending_person/trending_person.dart';

abstract class IPeopleRepository {
  Future<PersonDetails> getPersonById(int personId);
  Future<TrendingPerson> getTrendingPerson({required int page, required String timeToggle});
}
