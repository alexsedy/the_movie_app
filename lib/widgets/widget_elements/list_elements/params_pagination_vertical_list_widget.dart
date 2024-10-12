import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/models/interfaces/i_loading_status.dart';
import 'package:the_movie_app/models/models/parameterized_horizontal_widget_model.dart';

class ParameterizedPaginationVerticalListWidget<T extends ILoadingStatus> extends StatelessWidget {
  final T model;
  final ParameterizedWidgetModel paramModel;

  const ParameterizedPaginationVerticalListWidget({super.key,
    required this.model,
    required this.paramModel});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: paramModel.list.length,
        controller: paramModel.scrollController,
        itemExtent: 163,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemBuilder: (BuildContext context, int index) {
          var preLoad = paramModel.preLoad;
          if(preLoad != null) {
            preLoad(index);
          }

          String? posterPath = paramModel.list[index].imagePath;

          if (!model.isLoadingInProgress) {
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
                                  paramModel.list[index].firstLine ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5,),
                                Text(
                                  paramModel.list[index].secondLine ?? "",
                                  // movie.releaseDate,
                                  style: const TextStyle(
                                      color: Colors.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 15,),
                                Expanded(
                                  child: Text(
                                    paramModel.list[index].thirdLine ?? "",
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
                        paramModel.action(context, index);
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