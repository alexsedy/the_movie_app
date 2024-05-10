import 'package:flutter/material.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/belongs_to_collection_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/action_buttons/favorite_button_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/action_buttons/list_button_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/action_buttons/rate_button_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/action_buttons/watchlist_button_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/crew_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/media_details_list_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/overview_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/score_and_trailer_widget.dart';
import 'package:the_movie_app/widgets/tv_show_screens/tv_show_details_screen/tv_show_details_model.dart';

class TvShowDetailsMainInfoWidget extends StatelessWidget {
  const TvShowDetailsMainInfoWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<TvShowDetailsModel>(context);

    if(model == null) return const SizedBox.shrink();

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
        OverviewWidget<TvShowDetailsModel>(
          mediaDetailsElementType: MediaDetailsElementType.tv,
          model: model,
        ),
        if(model.mediaDetails?.belongsToCollection != null)
          BelongsToCollectionWidget<TvShowDetailsModel>(
            model: model,
          ),
        MediaCrewWidget<TvShowDetailsModel>(
          model: model,
          mediaDetailsElementType: MediaDetailsElementType.tv,
        ),
        MediaDetailsListWidget<TvShowDetailsModel>(
          mediaDetailsElementType: MediaDetailsElementType.tv,
          horizontalListElementType: HorizontalListElementType.cast,
          model: model,
        ),
        MediaDetailsListWidget<TvShowDetailsModel>(
          mediaDetailsElementType: MediaDetailsElementType.tv,
          horizontalListElementType: HorizontalListElementType.seasons,
          model: model,
        ),
        MediaDetailsListWidget<TvShowDetailsModel>(
          mediaDetailsElementType: MediaDetailsElementType.tv,
          horizontalListElementType: HorizontalListElementType.networks,
          model: model,
        ),
        MediaDetailsListWidget<TvShowDetailsModel>(
          mediaDetailsElementType: MediaDetailsElementType.tv,
          horizontalListElementType: HorizontalListElementType.companies,
          model: model,
        ),
        MediaDetailsListWidget<TvShowDetailsModel>(
          mediaDetailsElementType: MediaDetailsElementType.tv,
          horizontalListElementType: HorizontalListElementType.recommendations,
          model: model,
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