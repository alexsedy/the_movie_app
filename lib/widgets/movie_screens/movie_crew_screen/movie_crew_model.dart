import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/entity/movie_and_tv_show/credits/credits_details.dart';

class MovieCrewModel extends ChangeNotifier{
  final List<Crew>? _crew;

  List<Crew>? get crew {
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

    _crew?.sort((a, b) => (order[a.department] ?? 999) - (order[b.department] ?? 999));

    return _crew;
  }

  MovieCrewModel(this._crew);
}