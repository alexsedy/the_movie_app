import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/models/interfaces/i_base_media_details_model.dart';

class BelongsToCollectionWidget<T extends IBaseMediaDetailsModel> extends StatelessWidget {
  final T model;
  const BelongsToCollectionWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final belongsToCollection = model.mediaDetails?.belongsToCollection;
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