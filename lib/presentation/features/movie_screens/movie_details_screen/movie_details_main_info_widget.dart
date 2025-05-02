import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/core/constants/images_const/app_images.dart';
import 'package:the_movie_app/core/helpers/converter_helper.dart';
import 'package:the_movie_app/core/helpers/date_format_helper.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/movie_screens/movie_details_screen/viewmodel/movie_details_viewmodel.dart';
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

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsViewModel>();
    final readModel = context.read<MovieDetailsViewModel>();

    final overview = readModel.mediaDetails?.overview;
    final crew = readModel.mediaDetails?.credits.crew;
    final cast = readModel.mediaDetails?.credits.cast;
    final productionCompanies = readModel.mediaDetails?.productionCompanies;
    final recommendations = readModel.mediaDetails?.recommendations?.list;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SummaryMovieWidget(),
        ScoreAndTrailerWidget<MovieDetailsViewModel>(model: model),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ListButtonWidget<MovieDetailsViewModel>(
              mediaDetailsElementType: MediaDetailsElementType.movie,
              model: model,
            ),
            FavoriteButtonWidget<MovieDetailsViewModel>(
              mediaDetailsElementType: MediaDetailsElementType.movie,
              model: model,
            ),
            WatchlistButtonWidget<MovieDetailsViewModel>(
              model: model,
              mediaDetailsElementType: MediaDetailsElementType.movie,
            ),
            RateButtonWidget<MovieDetailsViewModel>(
              mediaDetailsElementType: MediaDetailsElementType.movie,
              model: model,
            ),
          ],
        ),

        if(overview != null && overview.isNotEmpty)
          OverviewWidget<MovieDetailsViewModel>(
          mediaDetailsElementType: MediaDetailsElementType.movie,
          model: model,
        ),

        if(model.mediaDetails?.belongsToCollection != null)
          BelongsToCollectionWidget<MovieDetailsViewModel>(
            model: model,
          ),

        if(crew != null && crew.isNotEmpty)
        ParameterizedMediaCrewWidget(
          paramsModel: ParameterizedWidgetModel(
            list: ConverterHelper.convertCrew(crew),
            action: (context, index) {},
            additionalText: context.l10n.movieCrew,
          ),
          secondAction: () => model.onCrewListScreen(context, crew),
        ),

        if(cast != null && cast.isNotEmpty)
        ParameterizedMediaDetailsListWidget(
          paramsModel: ParameterizedWidgetModel(
            list: ConverterHelper.convertCasts(cast),
            action: (context, index) => model.onPeopleDetailsScreen(context, index),
            additionalText: context.l10n.movieCast,
            altImagePath: AppImages.noProfile,
          ),
          secondAction: () => model.onCastListScreen(context, cast),
        ),

        if(productionCompanies != null && productionCompanies.isNotEmpty)
        ParameterizedMediaDetailsListWidget(
          paramsModel: ParameterizedWidgetModel(
            list: ConverterHelper.convertCompanies(productionCompanies),
            action: (context, index) {},
            additionalText: context.l10n.productionCompanies,
            altImagePath: AppImages.noLogo,
            aspectRatio: 1 / 1,
            boxHeight: AppSpacing.p216,
            paddingEdgeInsets: 4,
          ),
          secondAction: () {},
        ),

        if(recommendations != null && recommendations.isNotEmpty)
        ParameterizedMediaDetailsListWidget(
          paramsModel: ParameterizedWidgetModel(
            list: ConverterHelper.convertRecommendation(recommendations),
            action: (context, index) => model.onMediaDetailsScreen(context, index),
            additionalText: context.l10n.recommendationMovies,
            altImagePath: AppImages.noPoster,
          ),
          secondAction: () {},
        ),

        AppSpacing.gapH20,
      ],
    );
  }
}

class _SummaryMovieWidget extends StatelessWidget {
  const _SummaryMovieWidget({super.key});
  final double textSize = 16;

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieDetailsViewModel>();

    final movieDetails = model.mediaDetails;
    final releaseDates = model.mediaDetails?.releaseDates?.results;
    final status = model.mediaDetails?.status;

    final releaseDate = DateFormatHelper.fullShortDate(model.mediaDetails?.releaseDate);
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
        rating = releaseDates.firstWhere(
                (element) => element.iso == "US").releaseDates.first.certification;
      } catch (e) {
        rating = "";
      }
    }

    final countries = countriesList.join(" | ");
    final genres = genresList.join(" | ");

    return Padding(
      padding: AppSpacing.screenPaddingH60V16,
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
              if(status != null)
                TextSpan(
                  text: genres.isNotEmpty ? " ● " : "",
                  style: TextStyle(fontSize: textSize,),
                ),
              if(status != null)
                TextSpan(
                    text: status,
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
