import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/helpers/converter_helper.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/models/models/parameterized_horizontal_widget_model.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/list_screens/default_list/default_lists_model.dart';
import 'package:the_movie_app/widgets/widget_elements/list_elements/params_pagination_vertical_list_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/shimmer_skeleton_elements/list_shimmer_skeleton_widget.dart';

class DefaultListsWidget extends StatefulWidget {
  const DefaultListsWidget({super.key});

  @override
  State<DefaultListsWidget> createState() => _DefaultListsWidgetState();
}

class _DefaultListsWidgetState extends State<DefaultListsWidget> {
  @override
  void initState() {
    super.initState();
    NotifierProvider.read<DefaultListsModel>(context)?.loadMovies();
    NotifierProvider.read<DefaultListsModel>(context)?.loadTvShows();
  }

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
    final model = NotifierProvider.watch<DefaultListsModel>(context);

    if(model == null){
      return const SizedBox.shrink();
    }

    final listType = model.listType;

    switch(listType) {
      case ListType.favorites:
        return Text(context.l10n.favorite);
      case ListType.watchlist:
        return Text(context.l10n.watchlist);
      case ListType.rated:
        return Text(context.l10n.rated);
      case ListType.recommendations:
        return Text(context.l10n.recommendation);
    }
  }
}

class _MovieListWidget extends StatelessWidget {
  const _MovieListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<DefaultListsModel>(context);

    if(model == null){
      return const SizedBox.shrink();
    } else if (model.movies.isEmpty) {
      return FutureBuilder<void>(
        future: Future.delayed(const Duration(seconds: 2)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const DefaultListsShimmerSkeletonWidget();
          } else {
            return Center(
              child: Text(
                context.l10n.theListIsEmpty,
                style: const TextStyle(
                  fontSize: 36,
                ),
              ),
            );
          }
        },
      );
    }

    return ParameterizedPaginationVerticalListWidget(
      paramModel: ParameterizedWidgetModel(
        action: model.onMovieScreen,
        altImagePath: AppImages.noPoster,
        scrollController: model.scrollController,
        list: ConverterHelper.convertMoviesForVerticalWidget(model.movies),
      ),
      loadMoreItems: model.loadMovies,
    );
  }
}

class _TvShowListWidget extends StatelessWidget {
  const _TvShowListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<DefaultListsModel>(context);

    if(model == null){
      return const SizedBox.shrink();
    } else if (model.tvs.isEmpty) {
      return FutureBuilder<void>(
        future: Future.delayed(const Duration(seconds: 2)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const DefaultListsShimmerSkeletonWidget();
          } else {
            return Center(
              child: Text(
                context.l10n.theListIsEmpty,
                style: TextStyle(
                  fontSize: 36,
                ),
              ),
            );
          }
        },
      );
    }

    return ParameterizedPaginationVerticalListWidget(
      paramModel: ParameterizedWidgetModel(
        action: model.onTvShowScreen,
        altImagePath: AppImages.noPoster,
        scrollController: model.scrollController,
        list: ConverterHelper.convertTVShowsForVerticalWidget(model.tvs),
      ),
      loadMoreItems: model.loadTvShows,
    );
  }
}