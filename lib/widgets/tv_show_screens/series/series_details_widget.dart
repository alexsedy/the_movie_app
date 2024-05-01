import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/tv_show_screens/series/series_details_model.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/action_buttons/favorite_button_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/action_buttons/list_button_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/action_buttons/rate_button_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/action_buttons/watchlist_button_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/crew_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/media_details_list_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/overview_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/score_and_trailer_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/shimmer_skeleton_elements/media_details_shimmer_skeleton_widget.dart';

class SeriesDetailsWidget extends StatefulWidget {
  const SeriesDetailsWidget({super.key});

  @override
  State<SeriesDetailsWidget> createState() => _SeriesDetailsWidgetState();
}

class _SeriesDetailsWidgetState extends State<SeriesDetailsWidget> {
  @override
  void initState() {
    NotifierProvider.read<SeriesDetailsModel>(context)?.loadSeriesDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: const _SeriesNameWidget(),
       ),
       body: const _BodyDetails(),
    );
  }
}

class _SeriesNameWidget extends StatelessWidget {
  const _SeriesNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<SeriesDetailsModel>(context);
    final airDate = model?.mediaDetails?.airDate;
    final releaseText = airDate != null && airDate.isNotEmpty
        ? " (${airDate.substring(0, 4)})" : "";
    final name = model?.mediaDetails?.name;
    final episodeNumber = model?.episodeNumber;

    if(name == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name ?? ""),
        airDate != null
          ? Text(
              "Episode: $episodeNumber $releaseText",
              style: const TextStyle(fontStyle: FontStyle.italic),
            )
          : Text(
              "Episode: $episodeNumber",
              style: const TextStyle(fontStyle: FontStyle.italic),
            )
      ],
    );
  }
}

class _BodyDetails extends StatelessWidget {
  const _BodyDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<SeriesDetailsModel>(context);
    final mediaDetails = model?.mediaDetails;

    if(model == null || mediaDetails == null) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20,),
          OverviewWidget<SeriesDetailsModel>(
            mediaDetailsElementType: MediaDetailsElementType.series,
            model: model,
          ),
          MediaCrewWidget<SeriesDetailsModel>(
            model: model,
            mediaDetailsElementType: MediaDetailsElementType.series,
          ),
          MediaDetailsListWidget<SeriesDetailsModel>(
            mediaDetailsElementType: MediaDetailsElementType.series,
            horizontalListElementType: HorizontalListElementType.cast,
            model: model,
          ),
          MediaDetailsListWidget<SeriesDetailsModel>(
            mediaDetailsElementType: MediaDetailsElementType.series,
            horizontalListElementType: HorizontalListElementType.guestStars,
            model: model,
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }
}