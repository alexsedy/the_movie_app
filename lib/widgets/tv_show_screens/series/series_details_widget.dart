import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/helpers/converter_helper.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/models/models/parameterized_horizontal_widget_model.dart';
import 'package:the_movie_app/widgets/widget_elements/list_elements/params_media_details_list_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/list_elements/parameterized_media_crew_widget.dart';
import 'package:the_movie_app/widgets/tv_show_screens/series/series_details_model.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/overview_widget.dart';

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
  const _SeriesNameWidget();

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
        Text(name),
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
  const _BodyDetails();

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
          ParameterizedMediaCrewWidget(
            paramsModel: ParameterizedWidgetModel(
              list: ConverterHelper.convertCrew(model.mediaDetails?.credits.crew),
              action: (BuildContext context, int index) {},
              additionalText: "Series Crew",
            ),
            secondAction: () => model.onCrewListScreen(context, model.mediaDetails?.credits.crew),
          ),
          ParameterizedMediaDetailsListWidget(
            paramsModel: ParameterizedWidgetModel(
              list: ConverterHelper.convertCasts(model.mediaDetails?.credits.cast),
              action: model.onPeopleDetailsScreen,
              additionalText: "Series Cast",
              altImagePath: AppImages.noProfile,
            ),
            secondAction: () => model.onCastListScreen(context, model.mediaDetails?.credits.cast),
          ),
          ParameterizedMediaDetailsListWidget(
            paramsModel: ParameterizedWidgetModel(
              list: ConverterHelper.convertCasts(model.mediaDetails?.credits.guestStars),
              action: model.onGuestPeopleDetailsScreen,
              additionalText: "Series Guest Stars",
              altImagePath: AppImages.noProfile,
            ),
            secondAction: () => model.onGuestCastListScreen(context, model.mediaDetails?.credits.guestStars),
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }
}