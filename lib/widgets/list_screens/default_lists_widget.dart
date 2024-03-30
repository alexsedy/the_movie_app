import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/list_screens/default_lists_model.dart';
import 'package:the_movie_app/widgets/list_screens/lists_shimmer_skeleton_widget.dart';

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

    return ListView.builder(
        itemCount: model.movies.length,
        itemExtent: 163,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemBuilder: (BuildContext context, int index) {
          model.preLoadMovies(index);
          final movie = model.movies[index];
          final posterPath = movie.posterPath;
          if(!model.isLoadingInProgress) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.black.withOpacity(0.2)),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(1, 2),
                          )
                        ]
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Row(
                      children: [
                        AspectRatio(
                          aspectRatio: 500 / 750,
                          child: posterPath != null
                              ? Image.network(
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
                            ApiClient.getImageByUrl(posterPath), width: 95,)
                              : Image.asset(AppImages.noPoster, width: 95,),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 10, bottom: 1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 15,),
                                Text(
                                  movie.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5,),
                                Text(
                                  model.formatDate(movie.releaseDate),
                                  // movie.releaseDate,
                                  style: const TextStyle(color: Colors.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 15,),
                                Expanded(
                                  child: Text(
                                    movie.overview,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      onTap: () => model.onMovieTab(context, index),
                    ),
                  )
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }
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
    } else if (model.tvShows.isEmpty) {
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

    return ListView.builder(
        itemCount: model.tvShows.length,
        itemExtent: 163,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemBuilder: (BuildContext context, int index) {
          model.preLoadTvShows(index);
          final tvShow = model.tvShows[index];
          final posterPath = tvShow.posterPath;
          if(!model.isLoadingInProgress) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.black.withOpacity(0.2)),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(1, 2),
                          )
                        ]
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Row(
                      children: [
                        AspectRatio(
                          aspectRatio: 500 / 750,
                          child: posterPath != null
                              ? Image.network(
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
                            ApiClient.getImageByUrl(posterPath), width: 95,)
                              : Image.asset(AppImages.noPoster, width: 95,),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 10, bottom: 1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 15,),
                                Text(
                                  tvShow.originalName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5,),
                                Text(
                                  model.formatDate(tvShow.firstAirDate),
                                  // movie.releaseDate,
                                  style: const TextStyle(color: Colors.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 15,),
                                Expanded(
                                  child: Text(
                                    tvShow.overview,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      onTap: () => model.onTvShowTab(context, index),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }
    );
  }
}
