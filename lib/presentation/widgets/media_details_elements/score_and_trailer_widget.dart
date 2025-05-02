import 'package:flutter/material.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/presentation_models/interfaces/i_base_media_details_model.dart';
import 'package:the_movie_app/presentation/widgets/media_details_elements/score_radial_percent_widget.dart';

class ScoreAndTrailerWidget<T extends IBaseMediaDetailsModel> extends StatelessWidget {
  final T model;
  const ScoreAndTrailerWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final mediaDetails = model.mediaDetails;
    final voteAverage = mediaDetails?.voteAverage ?? 0;
    final voteAverageText = (voteAverage * 10).toStringAsFixed(0);
    final voteAverageScore = voteAverage / 10;

    final video = mediaDetails?.videos.results
        .where((element) => element.site == "YouTube" && element.type == "Trailer");

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 62,
          child: TextButton(
              onPressed: (){},
              child: Row(
                children: [
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: RadiantPercentWidget(
                      percent: voteAverageScore,
                      progressFreeColor: Colors.grey,
                      progressLine: voteAverage,
                      backgroundCircleColor: Colors.black87,
                      lineWidth: 3,
                      child: Text(
                        "$voteAverageText%",
                        style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  AppSpacing.gapW10,
                  Text(
                    context.l10n.userScore, 
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              )
          ),
        ),
        Container(width: 1, height: 15,color: Colors.grey,),
        SizedBox(
          height: 62,
          child: video != null && video.isNotEmpty
              ? TextButton(
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(context.l10n.trailers),
                      content: Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: video.map((item) => ListTile(
                              title: Text(item.name),
                              subtitle: Text(item.isoTwo),
                              onTap: () => model.launchYouTubeVideo(item.key),
                            ),).toList(),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(context.l10n.close),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Row(
                children: [
                  Icon(Icons.play_arrow, color: Theme.of(context).colorScheme.onSurface),
                  Text(
                    context.l10n.playTrailer,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  ),
                ],
              )
          )
              : SizedBox(
            height: 62,
            child: Center(
              child: Row(
                children: [
                  const Icon(Icons.play_arrow_outlined),
                  Text(
                    context.l10n.noTrailer,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}