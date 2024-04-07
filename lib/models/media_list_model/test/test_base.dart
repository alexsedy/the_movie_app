import 'package:the_movie_app/models/media_list_model/test/common_movie_list_model_mixin.dart';
import 'package:the_movie_app/models/media_list_model/test/common_trending_person_list_model_mixin.dart';

abstract class BaseList
    with CommonMovieListModelMixin,
    CommonTrendingPersonListModelMixin,
    CommonMovieListModelMixin {}