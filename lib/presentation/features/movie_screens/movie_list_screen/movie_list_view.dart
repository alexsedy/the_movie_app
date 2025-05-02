import 'dart:core';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_app/core/constants/images_const/app_images.dart';
import 'package:the_movie_app/core/helpers/converter_helper.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/movie_screens/movie_list_screen/viewmodel/movie_list_viewmodel.dart';
import 'package:the_movie_app/presentation/presentation_models/models/parameterized_horizontal_widget_model.dart';
import 'package:the_movie_app/presentation/widgets/list_elements/params_pagination_vertical_list_widget.dart';
import 'package:the_movie_app/presentation/widgets/shimmer_skeleton_elements/list_shimmer_skeleton_widget.dart';


class MovieListView extends StatefulWidget {
  const MovieListView({super.key});

  @override
  State<MovieListView> createState() => _MovieListViewState();
}

class _MovieListViewState extends State<MovieListView> {
  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieListViewModel>();

    if (model.movies.isEmpty && model.isLoadingInProgress) {
      return const DefaultListsShimmerSkeletonWidget();
    }

    if (model.movies.isEmpty && !model.isLoadingInProgress) {
      return Center(
        child: Text(
          context.l10n.noResults,
          style: Theme.of(context).textTheme.displaySmall,
        ),
      );
    }

    return ParameterizedPaginationVerticalListWidget(
      paramModel: ParameterizedWidgetModel(
        altImagePath: AppImages.noPoster,
        action: (context, index) => context.read<MovieListViewModel>().onMovieScreen(context, index),
        scrollController: model.scrollController,
        list: ConverterHelper.convertMoviesForVerticalWidget(model.movies),
        statuses: ConverterHelper.convertMovieStatuses(model.movieStatuses),
      ),
      loadMoreItems: context.read<MovieListViewModel>().loadContent,
    );
  }
}
