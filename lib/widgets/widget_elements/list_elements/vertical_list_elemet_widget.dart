import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/models/color_list_model/vertical_list_model.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';

class VerticalListElementWidget<T extends VerticalListModel> extends StatelessWidget {
  final VerticalListElementType verticalListElementType;
  final T model;
  const VerticalListElementWidget({super.key, required this.verticalListElementType, required this.model});

  @override
  Widget build(BuildContext context) {
    int itemCount = 0;

    switch(verticalListElementType) {
      case VerticalListElementType.seasonDetails:
        itemCount = model.season?.episodes.length ?? 0;
      case VerticalListElementType.collection:
        itemCount = model.mediaCollections?.parts?.length ?? 0;
    }

    return ListView.builder(
        itemCount: itemCount,
        itemExtent: 163,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemBuilder: (BuildContext context, int index) {

          String? posterPath;
          String? firstLine;
          String? secondLine;
          String? thirdLine;

          switch(verticalListElementType) {
            case VerticalListElementType.seasonDetails:
              posterPath = model.season?.episodes[index].stillPath;
              final name = model.season?.episodes[index].name;
              final episodeNumber = model.season?.episodes[index].episodeNumber;
              firstLine = "$episodeNumber. $name";
              final date = model.season?.episodes[index].airDate;
              secondLine = model.formatDate(date);
              thirdLine = model.season?.episodes[index].overview;
            case VerticalListElementType.collection:
              posterPath = model.mediaCollections?.parts?[index].posterPath;
              firstLine = model.mediaCollections?.parts?[index].title;
              final date = model.mediaCollections?.parts?[index].releaseDate;
              secondLine = model.formatDate(date);
              thirdLine = model.mediaCollections?.parts?[index].overview;
          }

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
                          ApiClient.getImageByUrl(posterPath), width: 95, fit: BoxFit.fitHeight,)
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
                              if(firstLine != null)
                              Text(
                                firstLine,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5,),
                              Text(
                                secondLine,
                                style: const TextStyle(
                                    color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 15,),
                              if(thirdLine != null)
                              Expanded(
                                child: Text(
                                  thirdLine,
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
                    onTap: () {
                      switch(verticalListElementType) {
                        case VerticalListElementType.seasonDetails:
                          model.onSeriesDetailsScreen(context, index);
                        case VerticalListElementType.collection:
                          model.onMediaDetailsScreen(context, index);
                      }
                    },
                  ),
                )
              ],
            ),
          );
        }
    );
  }
}