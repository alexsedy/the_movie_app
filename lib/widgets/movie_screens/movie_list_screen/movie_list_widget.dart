import 'dart:core';
import 'package:flutter/material.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/movie_screens/movie_list_screen/movie_list_model.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';
import 'package:the_movie_app/widgets/widget_elements/list_elements/vertical_list_element_widget.dart';
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

    return VerticalListElementWidget<MovieListModel>(
      verticalListElementType: VerticalListElementType.movie,
      model: model,
    );
  }
}