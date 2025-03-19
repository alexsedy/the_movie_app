import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/helpers/converter_helper.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/models/models/parameterized_horizontal_widget_model.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/home_screen/home_search_screen/home_search_model.dart';
import 'package:the_movie_app/widgets/widget_elements/list_elements/params_pagination_vertical_list_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/shimmer_skeleton_elements/list_shimmer_skeleton_widget.dart';

class HomeSearchWidget extends StatefulWidget {
  const HomeSearchWidget({super.key});

  @override
  State<HomeSearchWidget> createState() => _HomeSearchWidgetState();
}

class _HomeSearchWidgetState extends State<HomeSearchWidget> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    NotifierProvider.read<HomeSearchModel>(context)?.firstLoadAll();
    _selectedTab = NotifierProvider.read<HomeSearchModel>(context)?.index ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: _selectedTab,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.9,
          title: const _HeaderSearchBar(),
          leading: BackButton(
            onPressed: () {
              final model = NotifierProvider.read<HomeSearchModel>(context);
              model?.searchController.clear();
              model?.searchFocusNode.unfocus();
              Navigator.of(context).pop();
            },
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: context.l10n.movies),
              Tab(text: context.l10n.tvShows),
              Tab(text: context.l10n.persons),
              Tab(text: context.l10n.collections),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _MovieListWidget(),
            _TvShowListWidget(),
            _PersonListWidget(),
            _MediaCollectionListWidget(),
          ],
        ),
      ),
    );
  }
}

class _HeaderSearchBar extends StatelessWidget {
  const _HeaderSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<HomeSearchModel>(context);

    if (model == null) {
      return const SizedBox.shrink();
    }

    final searchController = model.searchController;
    final searchFocusNode = model.searchFocusNode;

    searchFocusNode.requestFocus();

    return Container(
      height: 45.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        focusNode: searchFocusNode,
        controller: searchController,
        onChanged: (value) {
          searchController.text = value;
          model.loadAll();
          if (value.isEmpty) {
            model.backOnHomePage(context);
          }
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _MovieListWidget extends StatelessWidget {
  const _MovieListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<HomeSearchModel>(context);

    if(model == null) return const SizedBox.shrink();

    if(model.movies.isEmpty) {
      return FutureBuilder<void>(
        future: Future.delayed(const Duration(seconds: 3)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const DefaultListsShimmerSkeletonWidget();
          } else {
            return Center(
              child: Text(
                context.l10n.noResults,
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
        altImagePath: AppImages.noPoster,
        action: model.onMovieScreen,
        scrollController: model.movieScrollController,
        list: ConverterHelper.convertMoviesForVerticalWidget(model.movies),
        statuses: ConverterHelper.convertMovieStatuses(model.movieStatuses),
      ),
      loadMoreItems: () => model.loadMovies(),
    );
  }
}

class _TvShowListWidget extends StatelessWidget {
  const _TvShowListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<HomeSearchModel>(context);

    if(model == null) return const SizedBox.shrink();

    if(model.tvs.isEmpty) {
      return FutureBuilder<void>(
        future: Future.delayed(const Duration(seconds: 3)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const DefaultListsShimmerSkeletonWidget();
          } else {
            return Center(
              child: Text(
                context.l10n.noResults,
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
        action: model.onTvShowScreen,
        altImagePath: AppImages.noPoster,
        scrollController: model.tvScrollController,
        list: ConverterHelper.convertTVShowsForVerticalWidget(model.tvs),
        statuses: ConverterHelper.convertTvShowStatuses(model.tvShowStatuses),
      ),
      loadMoreItems: model.loadTvShows,
    );
  }
}

class _PersonListWidget extends StatelessWidget {
  const _PersonListWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final model = NotifierProvider.watch<HomeSearchModel>(context);

    if(model == null) return const SizedBox.shrink();

    if(model.persons.isEmpty) {
      return FutureBuilder<void>(
        future: Future.delayed(const Duration(seconds: 3)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const DefaultListsShimmerSkeletonWidget();
          } else {
            return Center(
              child: Text(
                context.l10n.noResults,
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
        action: model.onPeopleDetailsScreen,
        altImagePath: AppImages.noProfile,
        scrollController: model.personScrollController,
        list: ConverterHelper.convertTrendingPeopleForHorizontalWidget(model.persons),
      ),
      loadMoreItems: model.loadPersons,
    );
  }
}

class _MediaCollectionListWidget extends StatelessWidget {
  const _MediaCollectionListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<HomeSearchModel>(context);

    if(model == null) return const SizedBox.shrink();

    if(model.collections.isEmpty) {
      return FutureBuilder<void>(
        future: Future.delayed(const Duration(seconds: 3)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const DefaultListsShimmerSkeletonWidget();
          } else {
            return Center(
              child: Text(
                context.l10n.noResults,
                style: const TextStyle(
                  fontSize: 36,
                ),
              ),
            );
          }
        },
      );
    }

    return ListView.builder(
      itemCount: model.collections.length,
      controller: model.collectionScrollController,
      itemExtent: 163,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemBuilder: (BuildContext context, int index) {
        model.preLoadCollections(index);
        final collections = model.collections;
        final backdropPath = collections[index].backdropPath;
        final name = collections[index].name;

        if (!model.isCollectionLoadingInProgress) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 150,
              child: Stack(
                children: [
                  backdropPath != null
                      ? Opacity(
                    opacity: 0.3,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Image.network(
                        fit: BoxFit.fill,
                        width: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        ApiClient.getImageByUrl(backdropPath),),
                    ),
                  )
                      : Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      border: Border.all(color: Colors.transparent),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  ListTile(
                    onTap: (){
                      model.onCollectionScreen(context, index);
                    },
                    minVerticalPadding: 0,
                    contentPadding: EdgeInsets.zero,
                    title: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }
}