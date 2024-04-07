import 'package:flutter/material.dart';
import 'package:the_movie_app/models/media_details_model/base_media_details_model.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/score_radial_percent_widget.dart';

class ScoreAndTrailerWidget<T extends BaseMediaDetailsModel> extends StatelessWidget {
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
                        style: const TextStyle(color: Colors.white),),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text("User Score", style: TextStyle(color: Colors.black),),
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
                      title: const Text('Trailers'),
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
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Row(
                children: [
                  Icon(Icons.play_arrow, color: Colors.black),
                  Text("Play Trailer", style: TextStyle(color: Colors.black),),
                ],
              )
          )
              : const SizedBox(
            width: 119,
            height: 62,
            child: Center(
              child: SizedBox(
                width: 95,
                height: 24,
                child: Center(
                  child: Row(
                    children: [
                      Icon(Icons.play_arrow_outlined),
                      Text(
                        "No Trailer",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}