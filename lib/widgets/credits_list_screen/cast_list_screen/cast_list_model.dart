import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/entity/person/credits_people/credits.dart';
import 'package:the_movie_app/models/color_list_model/cast_list_mixin.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class CastListModel extends ChangeNotifier with CastListMixin{
 final List<Cast> _cast;

 @override
 List<Cast> get cast => _cast;

 CastListModel(this._cast);

@override
 void onPeopleScreen(BuildContext context, int index) {
  final id = _cast[index].id;
  Navigator.of(context).pushNamed(MainNavigationRouteNames.personDetails, arguments: id);
 }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}