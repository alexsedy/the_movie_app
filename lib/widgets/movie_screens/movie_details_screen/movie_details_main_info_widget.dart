import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/helpers/converter_helper.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/models/models/parameterized_horizontal_widget_model.dart';
import 'package:the_movie_app/provider/provider.dart';
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
import 'package:the_movie_app/widgets/movie_screens/movie_details_screen/movie_details_model.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MovieDetailsWidget();
  }
}

class _MovieDetailsWidget extends StatelessWidget {
  const _MovieDetailsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);

    if(model == null) return const SizedBox.shrink();

    final overview = model.mediaDetails?.overview;
    final crew = model.mediaDetails?.credits.crew;
    final cast = model.mediaDetails?.credits.cast;
    final productionCompanies = model.mediaDetails?.productionCompanies;
    final recommendations = model.mediaDetails?.recommendations?.list;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SummaryMovieWidget(),
        ScoreAndTrailerWidget<MovieDetailsModel>(model: model),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ListButtonWidget<MovieDetailsModel>(
              mediaDetailsElementType: MediaDetailsElementType.movie,
              model: model,
            ),
            FavoriteButtonWidget<MovieDetailsModel>(
              mediaDetailsElementType: MediaDetailsElementType.movie,
              model: model,
            ),
            WatchlistButtonWidget<MovieDetailsModel>(
              mediaDetailsElementType: MediaDetailsElementType.movie,
              model: model,
            ),
            RateButtonWidget<MovieDetailsModel>(
              mediaDetailsElementType: MediaDetailsElementType.movie,
              model: model,
            ),
          ],
        ),

        if(overview != null && overview.isNotEmpty)
          OverviewWidget<MovieDetailsModel>(
          mediaDetailsElementType: MediaDetailsElementType.movie,
          model: model,
        ),

        if(model.mediaDetails?.belongsToCollection != null)
          BelongsToCollectionWidget<MovieDetailsModel>(
            model: model,
          ),

        if(crew != null && crew.isNotEmpty)
        ParameterizedMediaCrewWidget(
          paramsModel: ParameterizedWidgetModel(
            list: ConverterHelper.convertCrew(crew),
            action: (BuildContext context, int index) {},
            additionalText: context.l10n.movieCrew,
          ),
          secondAction: () => model.onCrewListScreen(context, crew),
        ),

        if(cast != null && cast.isNotEmpty)
        ParameterizedMediaDetailsListWidget(
          paramsModel: ParameterizedWidgetModel(
            list: ConverterHelper.convertCasts(cast),
            action: model.onPeopleDetailsScreen,
            additionalText: context.l10n.movieCast,
            altImagePath: AppImages.noProfile,
          ),
          secondAction: () => model.onCastListScreen(context, cast),
        ),

        if(productionCompanies != null && productionCompanies.isNotEmpty)
        ParameterizedMediaDetailsListWidget(
          paramsModel: ParameterizedWidgetModel(
            list: ConverterHelper.convertCompanies(productionCompanies),
            action: model.onPeopleDetailsScreen,
            additionalText: context.l10n.productionCompanies,
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
            additionalText: context.l10n.recommendationMovies,
            altImagePath: AppImages.noPoster,
          ),
          secondAction: () {},
        ),

        const SizedBox(height: 20,),
      ],
    );
  }
}

class _SummaryMovieWidget extends StatelessWidget {
  const _SummaryMovieWidget({super.key});
  final double textSize = 16;

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final movieDetails = model?.mediaDetails;
    final releaseDates = model?.mediaDetails?.releaseDates?.results;
    final releaseDate = model?.formatDate(movieDetails?.releaseDate);
    var countriesList = <String>[];
    var genresList = <String>[];

    if(movieDetails != null) {
      final productionCountries = movieDetails.productionCountries;
      if(productionCountries != null) {
        for (var country in productionCountries) {
          countriesList.add(country.iso);
        }
      }

      final genres = movieDetails.genres;
      if (genres != null) {
        for(var genre in genres) {
          genresList.add(genre.name);
        }
      }
    }

    String rating = "";
    if(releaseDates != null) {
      try {
        rating = releaseDates.firstWhere((element) => element.iso == "US").releaseDates.first.certification;
      } catch (e) {
        rating = "";
      }
    }

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
                // text: movieDetails?.runtime != null ? " ● " : "",
                style: TextStyle(fontSize: textSize,),
              ),
              TextSpan(
                  text: "${movieDetails?.runtime.toString()} ${context.l10n.min}",
                  style: TextStyle(
                    fontSize: textSize,
                  )
              ),
              TextSpan(
                text: releaseDate != "" ? " ● " : "",
                style: TextStyle(fontSize: textSize,),
              ),
              TextSpan(
                  text: releaseDate,
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