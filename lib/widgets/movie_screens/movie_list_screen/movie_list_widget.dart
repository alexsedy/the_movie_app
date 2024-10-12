import 'dart:core';
import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/models/models/parameterized_horizontal_widget_model.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/movie_screens/movie_list_screen/movie_list_model.dart';
import 'package:the_movie_app/helpers/converter_helper.dart';
import 'package:the_movie_app/widgets/widget_elements/list_elements/params_pagination_vertical_list_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/shimmer_skeleton_elements/list_shimmer_skeleton_widget.dart';


class MovieListWidget extends StatefulWidget {
  const MovieListWidget({super.key});

  @override
  State<MovieListWidget> createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieListModel>(context);

    if(model == null) return const SizedBox.shrink();

    if(model.movies.isEmpty) {
      return FutureBuilder<void>(
        future: Future.delayed(const Duration(milliseconds: 500)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const DefaultListsShimmerSkeletonWidget();
          } else {
            return const Center(
              child: Text(
                "No results.",
                style: TextStyle(
                  fontSize: 36,
                ),
              ),
            );
          }
        },
      );
    }

    // return VerticalListWithPaginationElementWidget<MovieListModel>(
    //   verticalListWithPaginationElementType: VerticalListWithPaginationElementType.movie,
    //   model: model,
    // );

    return ParameterizedPaginationVerticalListWidget(
      paramModel: ParameterizedWidgetModel(
        altImagePath: AppImages.noPoster,
        action: model.onMovieScreen,
        preLoad: model.preLoadMovies,
        scrollController: model.scrollController,
        list: ConverterHelper.convertMoviesForVerticalWidget(model.movies),
      ),
      model: model,
    );
  }
}