import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/movie_screens/movie_list_screen/movie_list_model.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';

class VerticalListElementWidget extends StatefulWidget {
  final VerticalListElementType verticalListElementType;
  const VerticalListElementWidget({super.key, required this.verticalListElementType,});

  @override
  State<VerticalListElementWidget> createState() => _VerticalListElementWidgetState();
}

class _VerticalListElementWidgetState extends State<VerticalListElementWidget> {
  late final ScrollController _scrollController;
  late final MovieListModel _model;
  bool isNotInit = true;

  @override
  void initState() {
    super.initState();
    switch(widget.verticalListElementType) {
      case VerticalListElementType.movie:
        _scrollController = NotifierProvider.read<MovieListModel>(context)?.scrollController ?? ScrollController();
      case VerticalListElementType.tv:
        // TODO: Handle this case.
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (isNotInit) {
      switch (widget.verticalListElementType) {
        case VerticalListElementType.movie:
          _model = NotifierProvider.watch<MovieListModel>(context) ??
              MovieListModel();
          isNotInit = false;
        case VerticalListElementType.tv:
        // TODO: Handle this case.
      }
    }

    return ListView.builder(
        controller: _scrollController,
        itemCount: _model.movies.length,
        itemExtent: 163,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemBuilder: (BuildContext context, int index) {
          _model.preLoadMovies(index);
          final movie = _model.movies[index];
          final posterPath = movie.posterPath;

          if (!_model.isLoadingInProgress) {
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
                                  _model.formatDate(movie.releaseDate),
                                  // movie.releaseDate,
                                  style: const TextStyle(
                                      color: Colors.grey),
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
                      borderRadius: const BorderRadius.all(Radius.circular(
                          10)),
                      onTap: () => _model.onMovieTab(context, index),
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