import 'package:flutter/material.dart';
import 'package:the_movie_app/models/media_details_model/base_media_details_model.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';
import 'package:the_movie_app/widgets/widget_elements/list_elements/horizontal_list_element_widget.dart';

class MediaDetailsListWidget<T extends BaseMediaDetailsModel> extends StatelessWidget {
  final MediaDetailsElementType mediaDetailsElementType;
  final HorizontalListElementType horizontalListElementType;
  final T model;
  const MediaDetailsListWidget({super.key,
    required this.mediaDetailsElementType,
    required this.model,
    required this.horizontalListElementType});

  @override
  Widget build(BuildContext context) {
    String text = "";

    switch(mediaDetailsElementType) {
      case MediaDetailsElementType.movie:
        text = "Movie";
      case MediaDetailsElementType.tv:
        text = "TV Show";
      case MediaDetailsElementType.series:
        text = "Series";
    }

    switch(horizontalListElementType) {
      case HorizontalListElementType.cast:
        final cast = model.mediaDetails?.credits.cast;
        if(cast == null) {
          return const SizedBox.shrink();
        } else if (cast.isEmpty) {
          return const SizedBox.shrink();
        }
        text = "$text Cast";
      case HorizontalListElementType.companies:
        final productionCompanies = model.mediaDetails?.productionCompanies;
        if(productionCompanies == null) {
          return const SizedBox.shrink();
        } else if (productionCompanies.isEmpty) {
          return const SizedBox.shrink();
        }
        text = "Production Companies";
      case HorizontalListElementType.seasons:
        final seasons = model.mediaDetails?.seasons;
        if(seasons == null) {
          return const SizedBox.shrink();
        } else if (seasons.isEmpty) {
          return const SizedBox.shrink();
        }
        text = "Seasons";
      case HorizontalListElementType.networks:
        final network = model.mediaDetails?.networks;
        if(network == null) {
          return const SizedBox.shrink();
        } else if (network.isEmpty) {
          return const SizedBox.shrink();
        }
        text = "Networks";
      case HorizontalListElementType.guestStars:
        final cast = model.mediaDetails?.credits.guestStars;
        if(cast == null) {
          return const SizedBox.shrink();
        } else if (cast.isEmpty) {
          return const SizedBox.shrink();
        }
        text = "$text Guest Stars";
      case HorizontalListElementType.movie:
        // TODO: Handle this case.
      case HorizontalListElementType.tv:
        // TODO: Handle this case.
      case HorizontalListElementType.trendingPerson:
        // TODO: Handle this case.
      case HorizontalListElementType.similar:
      final similar = model.mediaDetails?.similar?.list;
      if(similar == null) {
        return const SizedBox.shrink();
      } else if (similar.isEmpty) {
        return const SizedBox.shrink();
      }
      text = "Similar ${text}s";
      case HorizontalListElementType.recommendations:
        final recommendations = model.mediaDetails?.recommendations?.list;
        if(recommendations == null) {
          return const SizedBox.shrink();
        } else if (recommendations.isEmpty) {
          return const SizedBox.shrink();
        }
        text = "Recommendations ${text}s";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              switch(horizontalListElementType) {
                case HorizontalListElementType.cast:
                  model.onCastListScreen(context, model.mediaDetails?.credits.cast ?? []);
                case HorizontalListElementType.companies:
                  model.onCompaniesListScreen(context);
                case HorizontalListElementType.seasons:
                  model.onSeasonsListScreen(context, model.mediaDetails?.seasons ?? []);
                case HorizontalListElementType.networks:
                  model.onNetworksListScreen(context);
                case HorizontalListElementType.guestStars:
                  model.onGuestCastListScreen(context, model.mediaDetails?.credits.guestStars ?? []);
                case HorizontalListElementType.similar:
                  model.onSimilarListScreen(context, model.mediaDetails?.similar?.list ?? []);
                case HorizontalListElementType.recommendations:
                  model.onRecommendationsListScreen(context, model.mediaDetails?.recommendations?.list ?? []);
                default:
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                text,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        HorizontalListElementWidget<BaseMediaDetailsModel>(
          horizontalListElementType: horizontalListElementType,
          model: model,
        ),
      ],
    );
  }
}