import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/entity/movie_and_tv_show/credits/credits_details.dart';

class MovieCastModel extends ChangeNotifier{
 final List<Cast>? _cast;

 List<Cast>? get cast => _cast;

 MovieCastModel(this._cast);
}