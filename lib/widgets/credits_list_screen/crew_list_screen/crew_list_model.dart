import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/entity/person/credits_people/credits.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class CrewListModel extends ChangeNotifier {
  final List<Crew> _crew;

  List<Crew> get crew {
    // _crew?.sort((a, b) => a.department.compareTo(b.department));

    final order = {
      'Directing': 0,
      'Writing': 1,
      'Production': 2,
      'Sound': 3,
      'Camera': 4,
      'Editing': 5,
      'Visual Effects': 6,
      'Art': 7,
      'Costume & Make-Up': 8,
      'Crew': 9,
      'Lighting': 10,
    };

    _crew.sort((a, b) => (order[a.department] ?? 99) - (order[b.department] ?? 99));

    return _crew;
  }

  CrewListModel(this._crew);

  void onPeopleTab(BuildContext context, int index) {
    final id = _crew[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.personDetails, arguments: id);
  }
}