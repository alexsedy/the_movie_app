import 'package:flutter/material.dart';
import 'package:the_movie_app/data/models/person/credits_people/credits.dart';
import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';

class CastListViewModel extends ChangeNotifier {
  final List<Cast> _cast;

  CastListViewModel(this._cast);

  List<Cast> get cast => _cast;

  void onPeopleScreen(BuildContext context, int index) {
    if (index < 0 || index >= _cast.length) return;
    final id = _cast[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.personDetails, arguments: id);
  }
}
