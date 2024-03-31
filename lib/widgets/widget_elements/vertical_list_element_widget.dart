import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/movie_screens/movie_list_screen/movie_list_model.dart';
import 'package:the_movie_app/widgets/tv_show_screens/tv_show_list_screen/tv_show_list_model.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';

class VerticalListElementWidget extends StatefulWidget {
  final VerticalListElementType verticalListElementType;
  const VerticalListElementWidget({super.key, required this.verticalListElementType});

  @override
  State<VerticalListElementWidget> createState() => _VerticalListElementWidgetState();
}

class _VerticalListElementWidgetState extends State<VerticalListElementWidget> {
  late final ScrollController _scrollController;
  late final MovieListModel _modelMovie;
  late final TvShowListModel _modelTv;
  bool isNotInit = true;
  bool _isLoadingInProgress = true;


  @override
  void initState() {
    super.initState();
    switch(widget.verticalListElementType) {
      case VerticalListElementType.movie:
        _scrollController = NotifierProvider.read<MovieListModel>(context)?.scrollController ?? ScrollController();
      case VerticalListElementType.tv:
        _scrollController = NotifierProvider.read<TvShowListModel>(context)?.scrollController ?? ScrollController();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    int length = 0;

    if (isNotInit) {
      switch (widget.verticalListElementType) {
        case VerticalListElementType.movie:
          _modelMovie = NotifierProvider.watch<MovieListModel>(context) ??
              MovieListModel();
          isNotInit = false;
          length = _modelMovie.movies.length;
        case VerticalListElementType.tv:
          _modelTv = NotifierProvider.watch<TvShowListModel>(context) ??
              TvShowListModel();
          isNotInit = false;
          length = _modelTv.tvShows.length;
      }
    }

    return ListView.builder(
        controller: _scrollController,
        itemCount: length,
        itemExtent: 163,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemBuilder: (BuildContext context, int index) {
          String title = "";
          String overview = "";
          String date = "";
          String posterPath = "";

        switch (widget.verticalListElementType) {
          case VerticalListElementType.movie:
            _modelMovie.preLoadMovies(index);
            _isLoadingInProgress = _modelMovie.isLoadingInProgress;
            final movie = _modelMovie.movies[index];
            title = movie.title ?? "";
            posterPath = movie.posterPath ?? "";
            overview = movie.overview;
            date = _modelMovie.formatDate(movie.releaseDate);
          case VerticalListElementType.tv:
            _modelTv.preLoadTvShows(index);
            _isLoadingInProgress = _modelTv.isLoadingInProgress;
            final tvShow = _modelTv.tvShows[index];
            title = tvShow.name ?? "";
            posterPath = tvShow.posterPath ?? "";
            overview = tvShow.overview;
            date = _modelTv.formatDate(tvShow.firstAirDate);
        }

          if (!_isLoadingInProgress) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black.withOpacity(0.2)),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                          child: posterPath.isNotEmpty
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
                            ApiClient.getImageByUrl(posterPath), width: 95, fit: BoxFit.fitHeight,)
                              : Image.asset(AppImages.noPoster, width: 95, fit: BoxFit.fitHeight,),
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
                                  title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5,),
                                Text(
                                  date,
                                  // movie.releaseDate,
                                  style: const TextStyle(
                                      color: Colors.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 15,),
                                Expanded(
                                  child: Text(
                                    overview,
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
                      borderRadius: const BorderRadius.all(Radius.circular(
                          10)),
                      onTap: () {
                        switch(widget.verticalListElementType) {
                          case VerticalListElementType.movie:
                            _modelMovie.onMovieTab(context, index);
                          case VerticalListElementType.tv:
                            _modelTv.onTvShowTab(context, index);
                        }
                      },
                    ),
                  )
                ],
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