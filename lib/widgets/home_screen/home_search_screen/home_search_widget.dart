import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/helpers/converter_helper.dart';
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

  @override
  void initState() {
    super.initState();
    NotifierProvider.read<HomeSearchModel>(context)?.firstLoadAll();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.9,
          flexibleSpace: const _HeaderSearchBar(),
          leading: BackButton(
            onPressed: () {
              final model = NotifierProvider.read<HomeSearchModel>(context);
              model?.searchController.clear();
              Navigator.of(context).pop();
            },
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Movies"),
              Tab(text: "TV Shows"),
              Tab(text: "Persons"),
              Tab(text: "Collections"),
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

class _HeaderSearchBar extends StatefulWidget {
  const _HeaderSearchBar({super.key});

  @override
  State<_HeaderSearchBar> createState() => _HeaderSearchBarState();
}

class _HeaderSearchBarState extends State<_HeaderSearchBar> {
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final model = NotifierProvider.watch<HomeSearchModel>(context);

    if(model == null) {
      return const SizedBox.shrink();
    }

    final searchController = model.searchController;

    return Padding(
      padding: const EdgeInsets.only(left: 60, right: 16, top: 56),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextField(
          controller: searchController,
          focusNode: _searchFocusNode,
          onChanged: (value) {
            searchController.text = value;
            model.loadAll();
            if(value.isEmpty) {
              model.backOnHomePage(context);
            }
          },
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            // hintText: 'Find anything',
            border: InputBorder.none,
          ),
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

    return ParameterizedPaginationVerticalListWidget(
      paramModel: ParameterizedWidgetModel(
        action: model.onPeopleDetailsScreen,
        altImagePath: AppImages.noProfile,
        preLoad: model.preLoadPersons,
        scrollController: model.scrollController,
        list: ConverterHelper.convertTrendingPeopleForHorizontalWidget(model.persons),
      ),
      model: model,
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

    return ListView.builder(
      itemCount: model.collections.length,
      controller: model.scrollController,
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