import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/entity/person/credits_people/credits.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class CastListModel extends ChangeNotifier{
 final List<Cast>? _cast;

 List<Cast>? get cast => _cast;

 CastListModel(this._cast);

 void onPeopleTab(BuildContext context, int index) {
  final id = _cast?[index].id;
  Navigator.of(context).pushNamed(MainNavigationRouteNames.personDetails, arguments: id);
 }
}