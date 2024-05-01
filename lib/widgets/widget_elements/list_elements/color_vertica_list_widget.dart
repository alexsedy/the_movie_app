import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/models/color_list_model/base_list_model.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';

class ColorVerticalList<T extends BaseColorListModel> extends StatelessWidget {
  final T model;
  final ColorListType colorListType;
  const ColorVerticalList({super.key, required this.model, required this.colorListType});

  @override
  Widget build(BuildContext context) {

    int itemCount = 0;

    switch(colorListType) {
      case ColorListType.cast:
        itemCount = model.cast.length;
      case ColorListType.companies:

      case ColorListType.seasons:
        itemCount = model.seasons.length;
      case ColorListType.networks:
        // TODO: Handle this case.
      case ColorListType.seasonDetails:
        itemCount = model.season?.episodes.length ?? 0;
    }

    return ListView.builder(
      itemCount: itemCount,
      itemExtent: 180,
      itemBuilder: (BuildContext context, int index) {

        String? profilePath;
        String altImage = "";
        String? firstLine;
        String? secondLine;
        String? thirdLine;

        switch(colorListType) {
          case ColorListType.cast:
            profilePath = model.cast[index].profilePath;
            firstLine = model.cast[index].name;
            secondLine = model.cast[index].character;
            altImage = AppImages.noProfile;
          case ColorListType.companies:
          case ColorListType.seasons:
            profilePath = model.seasons[index].posterPath;
            firstLine = model.seasons[index].name;
            final episodeCount = model.seasons[index].episodeCount;
            secondLine = "$episodeCount episodes";
            thirdLine = model.formatDate(model.seasons[index].airDate);
            altImage = AppImages.noPoster;
          case ColorListType.networks:
            // TODO: Handle this case.
          case ColorListType.seasonDetails:
            profilePath = model.season?.episodes[index].stillPath;
            final name = model.season?.episodes[index].name;
            final episodeNumber = model.season?.episodes[index].episodeNumber;
            firstLine = "$episodeNumber. $name";
            final date = model.season?.episodes[index].airDate;
            secondLine = model.formatDate(date);
            thirdLine = model.season?.episodes[index].overview;
            altImage = AppImages.noProfile;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: SizedBox(
            child: Card(
              clipBehavior: Clip.hardEdge,
              child: ListTile(
                onTap: () {
                  switch(colorListType) {
                    case ColorListType.cast:
                      model.onPeopleScreen(context, index);
                    case ColorListType.companies:
                    case ColorListType.seasons:
                    model.onSeasonDetailsScreen(context, index);
                    case ColorListType.networks:
                    case ColorListType.seasonDetails:
                      model.onSeriesDetailsScreen(context, index);
                  }
                },
                minVerticalPadding: 0,
                contentPadding: EdgeInsets.zero,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 500 / 750,
                      child: profilePath != null
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
                        ApiClient.getImageByUrl(profilePath), fit: BoxFit.fitHeight,)
                          : Image.asset(altImage,),
                    ),
                    const SizedBox(width: 14,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6,),
                          Text(firstLine ?? "",
                            softWrap: true,
                            maxLines: colorListType != ColorListType.seasonDetails ? 3 : 1,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if(secondLine != null)
                          Text(secondLine,
                            softWrap: true,
                            maxLines: 3,
                            style: const TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 6,),
                          if(thirdLine != null)
                          Text(thirdLine,
                            maxLines: 3,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
