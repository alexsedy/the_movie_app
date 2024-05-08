import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/models/media_list_model/base_media_list_model.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';

class HorizontalListElementWidget<T extends BaseListModel> extends StatelessWidget {
  final HorizontalListElementType horizontalListElementType;
  final T model;
  const HorizontalListElementWidget({
    super.key, required this.horizontalListElementType, required this.model,
  });

  @override
  Widget build(BuildContext context) {
    int length = 0;
    double boxHeight = 0;
    double aspectRatio = 500 / 750;

    switch(horizontalListElementType) {
      case HorizontalListElementType.movie:
        length = model.movies.length;
        boxHeight = 280;
      case HorizontalListElementType.tv:
        length = model.tvs.length;
        boxHeight = 280;
      case HorizontalListElementType.trendingPerson:
        length = model.persons.length;
        boxHeight = 280;
      case HorizontalListElementType.cast:
        length =  model.mediaDetails?.credits.cast.length ?? 0;
        boxHeight = 280;
      case HorizontalListElementType.companies:
        length = model.mediaDetails?.productionCompanies?.length ?? 0;
        boxHeight = 215;
      case HorizontalListElementType.seasons:
        length = model.mediaDetails?.seasons?.length ?? 0;
        boxHeight = 280;
      case HorizontalListElementType.networks:
        length = model.mediaDetails?.networks?.length ?? 0;
        boxHeight = 215;
      case HorizontalListElementType.guestStars:
        length =  model.mediaDetails?.credits.guestStars?.length ?? 0;
        boxHeight = 280;
      case HorizontalListElementType.similar:
        length =  model.mediaDetails?.similar?.list.length ?? 0;
        boxHeight = 280;
      case HorizontalListElementType.recommendations:
        length =  model.mediaDetails?.recommendations?.list.length ?? 0;
        boxHeight = 280;
    }

    return SizedBox(
      height: boxHeight,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: length,
          itemExtent: 125,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemBuilder: (BuildContext context, int index) {

            String? posterPath;
            String altPosterPath = "";
            String firstLine = "";
            String secondLine = "";
            String thirdLine = "";

            switch(horizontalListElementType) {
              case HorizontalListElementType.movie:
                final movies = model.movies[index];
                posterPath = movies.posterPath;
                firstLine = movies.title ?? "";
                secondLine = model.formatDate(movies.releaseDate);
                altPosterPath = AppImages.noPoster;
              case HorizontalListElementType.tv:
                final tv = model.tvs[index];
                posterPath = tv.posterPath;
                firstLine = tv.name ?? "";
                secondLine = model.formatDate(tv.firstAirDate);
                altPosterPath = AppImages.noPoster;
              case HorizontalListElementType.trendingPerson:
                final person = model.persons[index];
                posterPath = person.profilePath;
                firstLine = person.name;
                secondLine = person.knownForDepartment ?? "";
                altPosterPath = AppImages.noProfile;
              case HorizontalListElementType.cast:
                final cast = model.mediaDetails?.credits.cast[index];
                posterPath = cast?.profilePath;
                firstLine = cast?.name ?? "";
                secondLine = cast?.character ?? "";
                altPosterPath = AppImages.noProfile;
              case HorizontalListElementType.companies:
                final productionCompanies = model.mediaDetails?.productionCompanies?[index];
                posterPath = productionCompanies?.logoPath;
                firstLine = productionCompanies?.name ?? "";
                altPosterPath = AppImages.noLogo;
                aspectRatio = 1 / 1;
              case HorizontalListElementType.seasons:
                final season =  model.mediaDetails?.seasons?[index];
                posterPath = season?.posterPath;
                firstLine = season?.name ?? "";
                final episodeCount = season?.episodeCount;
                secondLine = episodeCount != null ? "$episodeCount episodes" : "";
                thirdLine = model.formatDate(season?.airDate);
                altPosterPath = AppImages.noPoster;
              case HorizontalListElementType.networks:
                final networks = model.mediaDetails?.networks?[index];
                posterPath = networks?.logoPath;
                firstLine = networks?.name ?? "";
                altPosterPath = AppImages.noLogo;
              case HorizontalListElementType.guestStars:
                final guestStars = model.mediaDetails?.credits.guestStars?[index];
                posterPath = guestStars?.profilePath;
                firstLine = guestStars?.name ?? "";
                secondLine = guestStars?.character ?? "";
                altPosterPath = AppImages.noProfile;
              case HorizontalListElementType.similar:
                final similar = model.mediaDetails?.similar?.list[index];
                posterPath = similar?.posterPath;
                firstLine = similar?.title ?? similar?.name ?? "";
                final date = similar?.releaseDate ?? similar?.firstAirDate ?? "";
                secondLine = model.formatDate(date);
                altPosterPath = AppImages.noPoster;
              case HorizontalListElementType.recommendations:
                final recommendations = model.mediaDetails?.similar?.list[index];
                posterPath = recommendations?.posterPath;
                firstLine = recommendations?.title ?? recommendations?.name ?? "";;
                final date = recommendations?.releaseDate ?? recommendations?.firstAirDate ?? "";
                secondLine = model.formatDate(date);
                altPosterPath = AppImages.noPoster;
            }

            return Padding(
              padding: const EdgeInsets.all(8),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: aspectRatio,
                          child: posterPath != null
                              ? Padding(
                                padding: EdgeInsets.all(
                                    horizontalListElementType == HorizontalListElementType.companies
                                    ||  horizontalListElementType == HorizontalListElementType.networks
                                        ? 4.0
                                        : 0.0
                                ),
                                child: Image.network(
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: SizedBox(
                                      width: 60,
                                      height: 60,
                                        child: CircularProgressIndicator(),
                                      ),);},
                                  ApiClient.getImageByUrl(posterPath),),
                              )
                              : Image.asset(altPosterPath,),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 4, right: 2, top: 5),
                                child: Text(
                                  firstLine,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                              if(secondLine.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 4, right: 2, top: 5, bottom: 5),
                                child: Text(
                                  secondLine,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic
                                  ),
                                ),
                              ),
                              if(thirdLine.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 4, right: 2, top: 5, bottom: 5),
                                  child: Text(
                                    thirdLine,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      onTap: () {
                        switch(horizontalListElementType) {
                          case HorizontalListElementType.movie:
                            model.onMovieScreen(context, index);
                          case HorizontalListElementType.tv:
                            model.onTvShowScreen(context, index);
                          case HorizontalListElementType.trendingPerson:
                            model.onPeopleDetailsScreen(context, index);
                          case HorizontalListElementType.cast:
                            model.onPeopleDetailsScreen(context, index);
                          case HorizontalListElementType.companies:
                          case HorizontalListElementType.seasons:
                            model.onSeasonDetailsScreen(context, index);
                          case HorizontalListElementType.networks:
                          case HorizontalListElementType.guestStars:
                            model.onGuestPeopleDetailsScreen(context, index);
                          case HorizontalListElementType.similar:
                            model.onMediaDetailsScreen(context, index);
                          case HorizontalListElementType.recommendations:
                            model.onMediaDetailsScreen(context, index);
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          }
      ),
    );
  }
}