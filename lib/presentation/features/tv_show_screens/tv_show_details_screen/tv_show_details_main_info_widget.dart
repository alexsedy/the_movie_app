import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/core/constants/images_const/app_images.dart';
import 'package:the_movie_app/core/constants/widget_size.dart';
import 'package:the_movie_app/core/helpers/converter_helper.dart';
import 'package:the_movie_app/core/helpers/date_format_helper.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/tv_show_screens/tv_show_details_screen/viewmodel/tv_show_details_viewmodel.dart';
import 'package:the_movie_app/presentation/presentation_models/models/parameterized_horizontal_widget_model.dart';
import 'package:the_movie_app/presentation/widgets/enum_collection.dart';
import 'package:the_movie_app/presentation/widgets/list_elements/parameterized_media_crew_widget.dart';
import 'package:the_movie_app/presentation/widgets/list_elements/params_media_details_list_widget.dart';
import 'package:the_movie_app/presentation/widgets/media_details_elements/action_buttons/favorite_button_widget.dart';
import 'package:the_movie_app/presentation/widgets/media_details_elements/action_buttons/list_button_widget.dart';
import 'package:the_movie_app/presentation/widgets/media_details_elements/action_buttons/rate_button_widget.dart';
import 'package:the_movie_app/presentation/widgets/media_details_elements/action_buttons/watchlist_button_widget.dart';
import 'package:the_movie_app/presentation/widgets/media_details_elements/belongs_to_collection_widget.dart';
import 'package:the_movie_app/presentation/widgets/media_details_elements/overview_widget.dart';
import 'package:the_movie_app/presentation/widgets/media_details_elements/score_and_trailer_widget.dart';

class TvShowDetailsMainInfoWidget extends StatelessWidget {
  const TvShowDetailsMainInfoWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final model = context.watch<TvShowDetailsViewModel>();
    final readModel = context.read<TvShowDetailsViewModel>();

    final overview = readModel.mediaDetails?.overview;
    final productionCompanies = readModel.mediaDetails?.productionCompanies;
    final crew = readModel.mediaDetails?.credits.crew;
    final cast = readModel.mediaDetails?.credits.cast;
    final seasons = readModel.mediaDetails?.seasons;
    final networks = readModel.mediaDetails?.networks;
    final recommendations = readModel.mediaDetails?.recommendations?.list;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SummaryTvShowWidget(),
        ScoreAndTrailerWidget<TvShowDetailsViewModel>(model: model),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ListButtonWidget<TvShowDetailsViewModel>(
              mediaDetailsElementType: MediaDetailsElementType.tv,
              model: model,
            ),
            FavoriteButtonWidget<TvShowDetailsViewModel>(
              mediaDetailsElementType: MediaDetailsElementType.tv,
              model: model,
            ),
            WatchlistButtonWidget<TvShowDetailsViewModel>(
              model: model,
              mediaDetailsElementType: MediaDetailsElementType.tv,
            ),
            RateButtonWidget<TvShowDetailsViewModel>(
              mediaDetailsElementType: MediaDetailsElementType.tv,
              model: model,
            ),
          ],
        ),

        if(overview != null && overview.isNotEmpty)
        OverviewWidget<TvShowDetailsViewModel>(
          mediaDetailsElementType: MediaDetailsElementType.tv,
          model: model,
        ),

        if(model.mediaDetails?.belongsToCollection != null)
          BelongsToCollectionWidget<TvShowDetailsViewModel>(
            model: model,
          ),

        if(crew != null && crew.isNotEmpty)
        ParameterizedMediaCrewWidget(
          paramsModel: ParameterizedWidgetModel(
            list: ConverterHelper.convertCrew(crew),
            action: (BuildContext context, int index) {},
            additionalText: context.l10n.tvShowCrew,
          ),
          secondAction: () => model.onCrewListScreen(context, crew),
        ),

        if(cast != null && cast.isNotEmpty)
        ParameterizedMediaDetailsListWidget(
          paramsModel: ParameterizedWidgetModel(
            list: ConverterHelper.convertCasts(cast),
            action: (context, index) => model.onPeopleDetailsScreen(context, index),
            additionalText: context.l10n.tvShowCast,
            altImagePath: AppImages.noProfile,
          ),
          secondAction: () => model.onCastListScreen(context, cast),
        ),

        if(seasons != null && seasons.isNotEmpty)
        ParameterizedMediaDetailsListWidget(
          paramsModel: ParameterizedWidgetModel(
            list: ConverterHelper.convertSeasonHorizontal(seasons),
            action: model.onSeasonDetailsScreen,
            additionalText: context.l10n.seasons,
            altImagePath: AppImages.noPoster,
            statuses: ConverterHelper.convertWatchedSeasonsStatuses(model.seasonWatchStatuses),
          ),
          secondAction: () => model.onSeasonsListScreen(context, seasons),
        ),

        if(networks != null && networks.isNotEmpty)
        ParameterizedMediaDetailsListWidget(
          paramsModel: ParameterizedWidgetModel(
            list: ConverterHelper.convertNetworks(networks),
            action: (context, index) {},
            additionalText: context.l10n.networks,
            altImagePath: AppImages.noLogo,
            aspectRatio: 1 / 1,
            boxHeight: WidgetSize.size216,
            paddingEdgeInsets: 4,
          ),
          secondAction: () {},
        ),

        if(productionCompanies != null && productionCompanies.isNotEmpty)
        ParameterizedMediaDetailsListWidget(
          paramsModel: ParameterizedWidgetModel(
            list: ConverterHelper.convertCompanies(productionCompanies),
            action: (context, index) {},
            additionalText: context.l10n.productionCompanies,
            altImagePath: AppImages.noLogo,
            aspectRatio: 1 / 1,
            boxHeight: WidgetSize.size216,
            paddingEdgeInsets: 4,
          ),
          secondAction: () {},
        ),

        if(recommendations != null && recommendations.isNotEmpty)
        ParameterizedMediaDetailsListWidget(
          paramsModel: ParameterizedWidgetModel(
            list: ConverterHelper.convertRecommendation(recommendations),
            action:  (context, index) => model.onMediaDetailsScreen(context, index),
            additionalText: context.l10n.recommendationTvShows,
            altImagePath: AppImages.noPoster,
          ),
          secondAction: () => {},
        ),

        AppSpacing.gapH20,
      ],
    );
  }
}

class _SummaryTvShowWidget extends StatelessWidget {
  const _SummaryTvShowWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.read<TvShowDetailsViewModel>();

    final tvShowDetails = model.mediaDetails;
    final firstAirDate = model.mediaDetails?.firstAirDate;
    // final lastAirDate = model?.tvShowDetails?.lastAirDate;
    final ratingsList = tvShowDetails?.contentRatings?.ratingsList;
    final status = tvShowDetails?.status;

    var countriesList = <String>[];
    var genresList = <String>[];

    if(tvShowDetails != null) {
      final productionCountries = tvShowDetails.productionCountries;
      if(productionCountries != null) {
        for (var country in productionCountries) {
          countriesList.add(country.iso);
        }
      }

      final genres = tvShowDetails.genres;
      if (genres != null) {
        for(var genre in genres) {
          genresList.add(genre.name);
        }
      }
    }

    String rating = "";
    if(ratingsList != null) {
      try {
        rating = ratingsList.firstWhere((element) => element.iso == "US").rating;
      } catch (e) {
        rating = "";
      }
    }

    String? firstAirDateText;
    if(firstAirDate != null) {
      firstAirDateText = DateFormatHelper.fullShortDate(firstAirDate);
    }

    // String? lastAirDateText;
    // if(lastAirDate != null) {
    //   lastAirDateText = model?.formatDate(lastAirDate);
    // }

    final countries = countriesList.join(" | ");
    final genres = genresList.join(" | ");

    return Padding(
      padding: AppSpacing.screenPaddingH60V16,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            style: Theme.of(context).textTheme.titleMedium,
            children: [
              TextSpan(
                text: rating,
              ),
              TextSpan(
                text: rating.isNotEmpty ? " ● " : "",
              ),
              TextSpan(
                  text: firstAirDateText,
              ),
              TextSpan(
                text: countries.isNotEmpty ? " ● " : "",
              ),
              TextSpan(
                  text: countries.isNotEmpty ? countries : "",
              ),
              TextSpan(
                text: genres.isNotEmpty ? " ● " : "",
              ),
              TextSpan(
                  text: genres.isNotEmpty ? genres : "",
              ),
              if(status != null)
                TextSpan(
                  text: genres.isNotEmpty ? " ● " : "",
                ),
              if(status != null)
                TextSpan(
                    text: status,
                ),
            ]
        ),
      ),
    );
  }
}
