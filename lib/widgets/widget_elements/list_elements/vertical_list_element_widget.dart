import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/models/media_list_model/base_media_list_model.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';

class VerticalListElementWidget<T extends BaseListModel> extends StatelessWidget {
  final VerticalListElementType verticalListElementType;
  final T model;
  const VerticalListElementWidget({super.key, required this.verticalListElementType, required this.model});

  @override
  Widget build(BuildContext context) {
    int itemCount = 0;

    switch(verticalListElementType) {
      case VerticalListElementType.movie:
        itemCount = model.movies.length;
      case VerticalListElementType.tv:
        itemCount = model.tvs.length;
    }

    return ListView.builder(
        itemCount: itemCount,
        controller: model.scrollController,
        itemExtent: 163,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemBuilder: (BuildContext context, int index) {
          String title = "";
          String overview = "";
          String date = "";
          String? posterPath;
          bool isLoadingInProgress = false;

          switch(verticalListElementType) {
            case VerticalListElementType.movie:
              model.preLoadMovies(index);
              isLoadingInProgress = model.isMovieLoadingInProgress;
              final movie = model.movies[index];
              title = movie.title ?? "";
              overview = movie.overview;
              date = model.formatDate(movie.releaseDate);
              posterPath = movie.posterPath;
            case VerticalListElementType.tv:
              model.preLoadTvShows(index);
              isLoadingInProgress = model.isTvsLoadingInProgress;
              final tvs = model.tvs[index];
              title = tvs.name ?? "";
              overview = tvs.overview;
              date = model.formatDate(tvs.firstAirDate);
              posterPath = tvs.posterPath;
          }

          if (!isLoadingInProgress) {
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
                            ApiClient.getImageByUrl(posterPath), width: 95, fit: BoxFit.fill,)
                              : Image.asset(AppImages.noPoster, width: 95, fit: BoxFit.fill,),
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
                        switch(verticalListElementType) {
                          case VerticalListElementType.movie:
                            model.onMovieScreen(context, index);
                          case VerticalListElementType.tv:
                            model.onTvShowScreen(context, index);
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