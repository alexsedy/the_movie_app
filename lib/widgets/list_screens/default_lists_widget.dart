import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/helpers/converter_helper.dart';
import 'package:the_movie_app/models/models/parameterized_horizontal_widget_model.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/list_screens/default_lists_model.dart';
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
    NotifierProvider.read<DefaultListsModel>(context)?.firstLoadMovies();
    NotifierProvider.read<DefaultListsModel>(context)?.firstLoadTvShows();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const _HeaderWidget(),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Movies"),
              Tab(text: "TV Shows"),
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
        return const Text("Favorite list");
      case ListType.watchlist:
        return const Text("Watchlist list");
      case ListType.rated:
        return const Text("Rated list");
      case ListType.recommendations:
        return const Text("Recommendation list");
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
            return const Center(
              child: Text(
                "The list is empty.",
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
        action: model.onMovieScreen,
        altImagePath: AppImages.noPoster,
        preLoad: model.preLoadMovies,
        scrollController: model.scrollController,
        list: ConverterHelper.convertMoviesForVerticalWidget(model.movies),
      ),
      model: model,
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
            return const Center(
              child: Text(
                "The list is empty.",
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
        preLoad: model.preLoadTvShows,
        scrollController: model.scrollController,
        list: ConverterHelper.convertTVShowsForVerticalWidget(model.tvs),
      ),
      model: model,
    );
  }
}