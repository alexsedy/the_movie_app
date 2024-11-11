import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/domain/entity/media/list/list.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/ai_feature_screen/ai_list_recommendation/ai_recommendation_list_model.dart';
import 'package:the_movie_app/widgets/widget_elements/shimmer_skeleton_elements/list_shimmer_skeleton_widget.dart';

class AiRecommendationListScreenWidget extends StatelessWidget {
  const AiRecommendationListScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<AiRecommendationListModel>(context);

    if(model == null) {
      return SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(title: Text("AI Recommendation List")),
      body: StreamBuilder<List<MediaList>>(
        stream: model.generateAndGetMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AiListsShimmerSkeletonWidget();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemExtent: 163,
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                itemBuilder: (BuildContext context, int index) {
                  final posterPath = snapshot.data?[index].posterPath;
                  final title = snapshot.data?[index].title;
                  final releaseDate = snapshot.data?[index].releaseDate;
                  final overview = snapshot.data?[index].overview;

                  final name = snapshot.data?[index].name;
                  final firstAirDate = snapshot.data?[index].firstAirDate;

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
                                        Text(
                                         title ?? name ?? "",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5,),
                                        Text(
                                          releaseDate ?? firstAirDate ?? "",
                                          style: const TextStyle(
                                              color: Colors.grey),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 10,),
                                        Text(
                                          overview ?? "",
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
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
                              final id = snapshot.data?[index].id;
                              if(id != null) {
                                model.isMovie
                                    ? model.onMovieScreen(context, id)
                                    : model.onTvShowScreen(context, id);
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  );
                }
            );
          } else {
            return Center(child: Text('No date'));
          }
        },
      ),
    );
  }
}
