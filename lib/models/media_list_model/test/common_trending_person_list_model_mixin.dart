import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/entity/person/trending_person/trending_person.dart';

mixin CommonTrendingPersonListModelMixin {
  List<TrendingPersonList> get persons;

  Future<void> loadTrendingPerson();

  void onPeopleScreen(BuildContext context, int index);
}