import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/core/constants/images_const/app_images.dart';
import 'package:the_movie_app/core/constants/widget_size.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/data/models/media/list/list.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/ai_feature_screen/ai_list_recommendation/viewmodel/ai_recommendation_list_viewmodel.dart';
import 'package:the_movie_app/presentation/widgets/shimmer_skeleton_elements/list_shimmer_skeleton_widget.dart';

class AiRecommendationListView extends StatelessWidget {
  const AiRecommendationListView({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<AiRecommendationListViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.aiRecommendationList)),
      body: StreamBuilder<List<MediaList>>(
        stream: model.recommendationsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              (snapshot.connectionState == ConnectionState.active && !snapshot.hasData && !snapshot.hasError)) {
            return const AiListsShimmerSkeletonWidget();
          }
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          else if (snapshot.hasData) {
            final recommendations = snapshot.data!;
            if (recommendations.isEmpty) {
              return Center(child: Text(context.l10n.noResults));
            }
            return ListView.builder(
                itemCount: recommendations.length,
                itemExtent: WidgetSize.size180,
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                itemBuilder: (BuildContext context, int index) {
                  final item = recommendations[index];
                  final posterPath = item.posterPath;
                  final title = item.title;
                  final releaseDate = item.releaseDate;
                  final overview = item.overview;

                  final name = item.name;
                  final firstAirDate = item.firstAirDate;

                  return Padding(
                    padding: AppSpacing.screenPaddingH16V10,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(1, 2),
                                )
                              ]),
                          clipBehavior: Clip.hardEdge,
                          child: Row(
                            children: [
                              AspectRatio(/* ... */
                                aspectRatio: 500 / 750,
                                child: posterPath != null
                                    ? Image.network(
                                  ApiClient.getImageByUrl(posterPath),
                                  width: 95, fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) =>
                                  loadingProgress == null
                                      ? child
                                      : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset(AppImages.noPoster, width: 95, fit: BoxFit.cover),
                                )
                                    : Image.asset(AppImages.noPoster, width: 95, fit: BoxFit.cover),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: AppSpacing.screenPaddingL16R10B2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: AppSpacing.p16,),
                                        Text(
                                          title ?? name ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.bodyLarge,
                                        ),
                                      AppSpacing.gapH6,
                                        Text(
                                          releaseDate ?? firstAirDate ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      AppSpacing.gapH10,
                                        Text(
                                          overview ?? "",
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.bodyMedium,
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
                              final mediaType = snapshot.data?[index].mediaType;
                              if(id != null) {
                                if(mediaType != null) {
                                  model.onMediaScreen(context, id, mediaType);
                                } else {
                                  model.isMovie
                                      ? model.onMovieScreen(context, id)
                                      : model.onTvShowScreen(context, id);
                                }
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  );
                });
          }
          else {
            return Center(child: Text(context.l10n.noData));
          }
        },
      ),
    );
  }
}
