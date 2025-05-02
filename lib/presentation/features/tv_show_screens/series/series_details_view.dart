import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/core/constants/images_const/app_images.dart';
import 'package:the_movie_app/core/helpers/converter_helper.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/tv_show_screens/series/viewmodel/series_details_viewmodel.dart';
import 'package:the_movie_app/presentation/presentation_models/models/parameterized_horizontal_widget_model.dart';
import 'package:the_movie_app/presentation/widgets/enum_collection.dart';
import 'package:the_movie_app/presentation/widgets/list_elements/parameterized_media_crew_widget.dart';
import 'package:the_movie_app/presentation/widgets/list_elements/params_media_details_list_widget.dart';
import 'package:the_movie_app/presentation/widgets/media_details_elements/overview_widget.dart';

class SeriesDetailsView extends StatelessWidget {
  const SeriesDetailsView({super.key});

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
    final model = context.watch<SeriesDetailsViewModel>();
    final airDate = model.mediaDetails?.airDate;
    final releaseText = airDate != null && airDate.isNotEmpty
        ? " (${airDate.substring(0, 4)})" : "";
    final name = model.mediaDetails?.name;
    final episodeNumber = model.episodeNumber;

    if(name == null) {
      return AppSpacing.emptyGap;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        airDate != null
          ? Text(
              "${context.l10n.episode}: $episodeNumber $releaseText",
              style: const TextStyle(fontStyle: FontStyle.italic),
            )
          : Text(
              "${context.l10n.episode}: $episodeNumber",
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
        Text(name),
      ],
    );
  }
}

class _BodyDetails extends StatelessWidget {
  const _BodyDetails();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<SeriesDetailsViewModel>();
    final mediaDetails = model.mediaDetails;

    if(mediaDetails == null) {
      return AppSpacing.emptyGap;
    }

    final overview = mediaDetails.overview;
    final cast = mediaDetails.credits.cast;
    final crew = mediaDetails.credits.crew;
    final guestStars = mediaDetails.credits.guestStars;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.gapH20,
          _WatchListButton(),

          if(overview != null && overview.isNotEmpty)
            AppSpacing.gapH20,

          if(overview != null && overview.isNotEmpty)
          OverviewWidget<SeriesDetailsViewModel>(
            mediaDetailsElementType: MediaDetailsElementType.series,
            model: model,
          ),

          if(crew.isNotEmpty)
          ParameterizedMediaCrewWidget(
            paramsModel: ParameterizedWidgetModel(
              list: ConverterHelper.convertCrew(crew),
              action: (BuildContext context, int index) {},
              additionalText: context.l10n.seriesCrew,
            ),
            secondAction: () => model.onCrewListScreen(context, crew),
          ),

          if(cast.isNotEmpty)
          ParameterizedMediaDetailsListWidget(
            paramsModel: ParameterizedWidgetModel(
              list: ConverterHelper.convertCasts(cast),
              action: model.onPeopleDetailsScreen,
              additionalText: context.l10n.seriesCast,
              altImagePath: AppImages.noProfile,
            ),
            secondAction: () => model.onCastListScreen(context, cast),
          ),

          if(guestStars != null && guestStars.isNotEmpty)
          ParameterizedMediaDetailsListWidget(
            paramsModel: ParameterizedWidgetModel(
              list: ConverterHelper.convertCasts(guestStars),
              action: model.onGuestPeopleDetailsScreen,
              additionalText: context.l10n.seriesGuestStars,
              altImagePath: AppImages.noProfile,
            ),
            secondAction: () => model.onGuestCastListScreen(context, guestStars),
          ),
          AppSpacing.gapH20,
        ],
      ),
    );
  }
}

class _WatchListButton extends StatelessWidget {
  const _WatchListButton({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<SeriesDetailsViewModel>();
    final currentStatus = context.select<SeriesDetailsViewModel, int?>((m) => m.currentStatus);

    if(currentStatus == null) {
      return AppSpacing.emptyGap;
    }

    return Center(
      child: ElevatedButton(
        onPressed: () {
            model.updateStatus(context, currentStatus,);
        },
        child: Text(context.l10n.mediaStatus("status_$currentStatus")),
        style: ButtonStyle(
          backgroundColor: currentStatus == 1
              ? WidgetStatePropertyAll(Colors.green.withAlpha(150),)
              : null,
        ),
      ),
    );
  }
}
