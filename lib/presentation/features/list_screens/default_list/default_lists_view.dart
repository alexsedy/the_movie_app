import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_app/core/constants/images_const/app_images.dart';
import 'package:the_movie_app/core/helpers/converter_helper.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/list_screens/default_list/viewmodel/default_lists_viewmodel.dart';
import 'package:the_movie_app/presentation/presentation_models/models/parameterized_horizontal_widget_model.dart';
import 'package:the_movie_app/presentation/widgets/list_elements/params_pagination_vertical_list_widget.dart';
import 'package:the_movie_app/presentation/widgets/list_elements/params_vertical_list_widget.dart';
import 'package:the_movie_app/presentation/widgets/shimmer_skeleton_elements/list_shimmer_skeleton_widget.dart';

class DefaultListsView extends StatelessWidget {
  const DefaultListsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const _HeaderWidget(),
          bottom: TabBar(
            tabs: [
              Tab(text: context.l10n.movies),
              Tab(text: context.l10n.tvShows),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _MovieListWidget(),
            _TvShowListWidget(),
          ],
        ),
      ),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final listType = context.read<DefaultListsViewModel>().listType;

    switch(listType) {
      case ListType.favorites:
        return Text(context.l10n.favorite);
      case ListType.watchlist:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.l10n.watchlist),
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.sort),
            ),
          ],
        );
      case ListType.rated:
        return Text(context.l10n.rated);
      case ListType.recommendations:
        return Text(context.l10n.recommendation);
    }
  }
}

class _MovieListWidget extends StatelessWidget {
  const _MovieListWidget();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DefaultListsViewModel>();
    final bool isWatchlist = viewModel.listType == ListType.watchlist;

    if (viewModel.movies.isEmpty && (isWatchlist
        ? viewModel.isWatchlistLoading
        : viewModel.isMovieLoadingInProgress)) {
      return const DefaultListsShimmerSkeletonWidget();
    }
    if (viewModel.movies.isEmpty && !(isWatchlist
        ? viewModel.isWatchlistLoading
        : viewModel.isMovieLoadingInProgress)) {
      return Center(child: Text(context.l10n.theListIsEmpty));
    }

    final paramModel = ParameterizedWidgetModel(
      action: (ctx, index) => ctx.read<DefaultListsViewModel>().onMovieScreen(context, index),
      altImagePath: AppImages.noPoster,
      scrollController: viewModel.movieScrollController,
      list: ConverterHelper.convertMoviesForVerticalWidget(viewModel.movies),
      statuses: isWatchlist ? ConverterHelper.convertMovieStatuses(viewModel.movieStatuses) : null,
    );

    return isWatchlist
        ? ParameterizedVerticalListWidget(paramModel: paramModel)
        : ParameterizedPaginationVerticalListWidget(
      paramModel: paramModel,
      loadMoreItems: context.read<DefaultListsViewModel>().loadMovies,
    );
  }
}

class _TvShowListWidget extends StatelessWidget {
  const _TvShowListWidget();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DefaultListsViewModel>();
    final bool isWatchlist = viewModel.listType == ListType.watchlist;

    if (viewModel.tvs.isEmpty && (isWatchlist ? viewModel.isWatchlistLoading : viewModel.isTvShowLoadingInProgress)) {
      return const DefaultListsShimmerSkeletonWidget();
    }
    if (viewModel.tvs.isEmpty && !(isWatchlist ? viewModel.isWatchlistLoading : viewModel.isTvShowLoadingInProgress)) {
      return Center(child: Text(context.l10n.theListIsEmpty));
    }

    final paramModel = ParameterizedWidgetModel(
      action: (ctx, index) => ctx.read<DefaultListsViewModel>().onTvShowScreen(context, index),
      altImagePath: AppImages.noPoster,
      scrollController: viewModel.tvScrollController,
      list: ConverterHelper.convertTVShowsForVerticalWidget(viewModel.tvs),
      statuses: isWatchlist ? ConverterHelper.convertTvShowStatuses(viewModel.tvShowStatuses) : null,
    );

    return isWatchlist
        ? ParameterizedVerticalListWidget(paramModel: paramModel)
        : ParameterizedPaginationVerticalListWidget(
      paramModel: paramModel,
      loadMoreItems: context.read<DefaultListsViewModel>().loadTvShows,
    );
  }
}
