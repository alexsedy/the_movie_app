import 'package:flutter/material.dart';
import 'package:the_movie_app/data/models/person/credits_people/credits.dart';
import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';

class CrewListViewModel extends ChangeNotifier {
  final List<Crew> _crew;

  static const _departmentOrder = {
    'Directing': 0, 'Writing': 1, 'Production': 2, 'Sound': 3,
    'Camera': 4, 'Editing': 5, 'Visual Effects': 6, 'Art': 7,
    'Costume & Make-Up': 8, 'Crew': 9, 'Lighting': 10,
  };

  CrewListViewModel(this._crew);

  List<Crew> get crew {
    final sortedCrew = List<Crew>.from(_crew);
    sortedCrew.sort((a, b) {
      final orderA = _departmentOrder[a.department] ?? 99;
      final orderB = _departmentOrder[b.department] ?? 99;
      return orderA.compareTo(orderB);
    });
    return sortedCrew;
  }

  void onPeopleTab(BuildContext context, int index) {
    if (index < 0 || index >= crew.length) return;
    final id = crew[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.personDetails, arguments: id);
  }
}