import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/models/media_details_model/base_media_details_model.dart';

class BelongsToCollectionWidget<T extends BaseMediaDetailsModel> extends StatelessWidget {
  final T model;
  const BelongsToCollectionWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final belongsToCollection = model.mediaDetails?.belongsToCollection;
    final posterPath = belongsToCollection?.posterPath;
    final backdropPath = belongsToCollection?.backdropPath;
    final name = belongsToCollection?.name;

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
                model.onCollectionScreen(context);
              },
              minVerticalPadding: 0,
              contentPadding: EdgeInsets.zero,
              title: Center(
                child: Text(
                  name?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BelongsToCollectionWidgetTwo<T extends BaseMediaDetailsModel> extends StatelessWidget {
  final T model;
  const BelongsToCollectionWidgetTwo({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final belongsToCollection = model.mediaDetails?.belongsToCollection;
    final posterPath = belongsToCollection?.posterPath;
    final backdropPath = belongsToCollection?.backdropPath;
    final name = belongsToCollection?.name;

    if(backdropPath == null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 150,
          child: Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.hardEdge,
            child: ListTile(
              onTap: () {},
              minVerticalPadding: 0,
              contentPadding: EdgeInsets.zero,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 500 / 750,
                    child: posterPath != null
                        ? Image.network(
                      repeat: ImageRepeat.repeatX,
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
                      ApiClient.getImageByUrl(posterPath),
                      fit: BoxFit.fitHeight,)
                        : Image.asset(AppImages.noPoster,),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        name ?? "",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 150,
          child: Stack(
            children: [
              Opacity(
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
              ),
              ListTile(
                onTap: (){},
                minVerticalPadding: 0,
                contentPadding: EdgeInsets.zero,
                title: Center(
                  child: Text(
                    name?? "",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}