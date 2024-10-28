import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/helpers/converter_helper.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/models/models/parameterized_horizontal_widget_model.dart';
import 'package:the_movie_app/widgets/widget_elements/list_elements/params_media_details_list_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/list_elements/parameterized_media_crew_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/belongs_to_collection_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/action_buttons/favorite_button_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/action_buttons/list_button_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/action_buttons/rate_button_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/action_buttons/watchlist_button_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/overview_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/score_and_trailer_widget.dart';
import 'package:the_movie_app/widgets/tv_show_screens/tv_show_details_screen/tv_show_details_model.dart';

class TvShowDetailsMainInfoWidget extends StatelessWidget {
  const TvShowDetailsMainInfoWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<TvShowDetailsModel>(context);

    if(model == null) return const SizedBox.shrink();

    final overview = model.mediaDetails?.overview;
    final productionCompanies = model.mediaDetails?.productionCompanies;
    final crew = model.mediaDetails?.credits.crew;
    final cast = model.mediaDetails?.credits.cast;
    final seasons = model.mediaDetails?.seasons;
    final networks = model.mediaDetails?.networks;
    final recommendations = model.mediaDetails?.recommendations?.list;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SummaryTvShowWidget(),
        ScoreAndTrailerWidget<TvShowDetailsModel>(model: model),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ListButtonWidget<TvShowDetailsModel>(
              mediaDetailsElementType: MediaDetailsElementType.tv,
              model: model,
            ),
            FavoriteButtonWidget<TvShowDetailsModel>(
              mediaDetailsElementType: MediaDetailsElementType.tv,
              model: model,
            ),
            WatchlistButtonWidget<TvShowDetailsModel>(
              mediaDetailsElementType: MediaDetailsElementType.tv,
              model: model,
            ),
            RateButtonWidget<TvShowDetailsModel>(
              mediaDetailsElementType: MediaDetailsElementType.tv,
              model: model,
            ),
          ],
        ),

        if(overview != null && overview.isNotEmpty)
        OverviewWidget<TvShowDetailsModel>(
          mediaDetailsElementType: MediaDetailsElementType.tv,
          model: model,
        ),

        if(model.mediaDetails?.belongsToCollection != null)
          BelongsToCollectionWidget<TvShowDetailsModel>(
            model: model,
          ),

        if(crew != null && crew.isNotEmpty)
        ParameterizedMediaCrewWidget(
          paramsModel: ParameterizedWidgetModel(
            list: ConverterHelper.convertCrew(crew),
            action: (BuildContext context, int index) {},
            additionalText: "TV Show Crew",
          ),
          secondAction: () => model.onCrewListScreen(context, crew),
        ),

        if(cast != null && cast.isNotEmpty)
        ParameterizedMediaDetailsListWidget(
          paramsModel: ParameterizedWidgetModel(
            list: ConverterHelper.convertCasts(cast),
            action: model.onPeopleDetailsScreen,
            additionalText: "TV Show Cast",
            altImagePath: AppImages.noProfile,
          ),
          secondAction: () => model.onCastListScreen(context, cast),
        ),

        if(seasons != null && seasons.isNotEmpty)
        ParameterizedMediaDetailsListWidget(
          paramsModel: ParameterizedWidgetModel(
            list: ConverterHelper.convertSeasonHorizontal(seasons),
            action: model.onSeasonDetailsScreen,
            additionalText: "Seasons",
            altImagePath: AppImages.noPoster,
          ),
          secondAction: () => model.onSeasonsListScreen(context, seasons),
        ),

        if(networks != null && networks.isNotEmpty)
        ParameterizedMediaDetailsListWidget(
          paramsModel: ParameterizedWidgetModel(
            list: ConverterHelper.convertNetworks(networks),
            action: model.onPeopleDetailsScreen,
            additionalText: "Networks",
            altImagePath: AppImages.noLogo,
            aspectRatio: 1 / 1,
            boxHeight: 215,
            paddingEdgeInsets: 4,
          ),
          secondAction: () {},
        ),

        if(productionCompanies != null && productionCompanies.isNotEmpty)
        ParameterizedMediaDetailsListWidget(
          paramsModel: ParameterizedWidgetModel(
            list: ConverterHelper.convertCompanies(productionCompanies),
            action: model.onPeopleDetailsScreen,
            additionalText: "Production Companies",
            altImagePath: AppImages.noLogo,
            aspectRatio: 1 / 1,
            boxHeight: 215,
            paddingEdgeInsets: 4,
          ),
          secondAction: () {},
        ),

        if(recommendations != null && recommendations.isNotEmpty)
        ParameterizedMediaDetailsListWidget(
          paramsModel: ParameterizedWidgetModel(
            list: ConverterHelper.convertRecommendation(recommendations),
            action: model.onMediaDetailsScreen,
            additionalText: "Recommendation TV Shows",
            altImagePath: AppImages.noPoster,
          ),
          secondAction: () => {},
        ),

        const SizedBox(height: 20,),
      ],
    );
  }
}

class _SummaryTvShowWidget extends StatelessWidget {
  const _SummaryTvShowWidget();
  final double textSize = 16;

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<TvShowDetailsModel>(context);
    final tvShowDetails = model?.mediaDetails;
    final firstAirDate = model?.mediaDetails?.firstAirDate;
    // final lastAirDate = model?.tvShowDetails?.lastAirDate;
    final ratingsList = tvShowDetails?.contentRatings?.ratingsList;

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
      firstAirDateText = model?.formatDate(firstAirDate);
    }

    // String? lastAirDateText;
    // if(lastAirDate != null) {
    //   lastAirDateText = model?.formatDate(lastAirDate);
    // }

    final countries = countriesList.join(" | ");
    final genres = genresList.join(" | ");

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: rating,
                style: TextStyle(
                  fontSize: textSize,
                ),
              ),
              TextSpan(
                text: rating.isNotEmpty ? " ● " : "",
                style: TextStyle(fontSize: textSize,),
              ),
              TextSpan(
                  text: firstAirDateText,
                  style: TextStyle(
                    fontSize: textSize,
                  )
              ),
              TextSpan(
                text: countries.isNotEmpty ? " ● " : "",
                style: TextStyle(fontSize: textSize,),
              ),
              TextSpan(
                  text: countries.isNotEmpty ? countries : "",
                  style: TextStyle(
                    fontSize: textSize,
                  )
              ),
              TextSpan(
                text: genres.isNotEmpty ? " ● " : "",
                style: TextStyle(fontSize: textSize,),
              ),
              TextSpan(
                  text: genres.isNotEmpty ? genres : "",
                  style: TextStyle(
                    fontSize: textSize,
                  )
              ),
            ]
        ),
      ),
    );
  }
}