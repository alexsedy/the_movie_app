import 'package:flutter/material.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/elements/score_radial_percent_widget.dart';
import 'package:the_movie_app/widgets/movie_details_screen/movie_details_model.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SummaryMovieWidget(),
        _ScoreAndTrailerWidget(),
        _ActionButtonsWidget(),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text("Overview", style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),),
        ),
        _TaglineWidget(),
        _DescriptionWidget(),
        SizedBox(height: 30,),
        _PeopleWidget(),
      ],
    );
  }
}

class _ActionButtonsWidget extends StatelessWidget {
  const _ActionButtonsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: (){},
            child: SizedBox(
              width: 60,
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.list),
                  const Text("List"),
                ],
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: (){},
            child: SizedBox(
              width: 60,
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite),
                  const Text("Favorite"),
                ],
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: (){},
            child: Container(
              width: 60,
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark),
                  const Text("Watch"),
                ],
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: (){},
            child: SizedBox(
              width: 60,
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star),
                  const Text("Rate"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreAndTrailerWidget extends StatelessWidget {
  const _ScoreAndTrailerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final movieDetails = NotifierProvider.watch<MovieDetailsModel>(context)?.movieDetails;
    final voteAverage = movieDetails?.voteAverage ?? 0;
    final voteAverageText = (voteAverage * 10).toStringAsFixed(0);
    final voteAverageScore = voteAverage / 10;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
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
        Container(width: 1, height: 15,color: Colors.grey,),
        TextButton(
          onPressed: (){},
          child: const Row(
            children: [
              Icon(Icons.play_arrow, color: Colors.black),
              Text("Play Trailer", style: TextStyle(color: Colors.black),),
            ],
          )
        ),
      ],
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final movieDetails = NotifierProvider.watch<MovieDetailsModel>(context)?.movieDetails;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(movieDetails?.overview ?? ""),
    );
  }
}

class _TaglineWidget extends StatelessWidget {
  const _TaglineWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final movieDetails = NotifierProvider.watch<MovieDetailsModel>(context)?.movieDetails;
    final tagline = movieDetails?.tagline;

    if (tagline == null || tagline == "") {
      return const SizedBox.shrink();
    } else {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Text("\"$tagline\"",
          style: const TextStyle(fontSize: 21, fontStyle: FontStyle.italic),),
      );
    }
  }
}

class _SummaryMovieWidget extends StatelessWidget {
  const _SummaryMovieWidget({super.key});
  final double textSize = 16;

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final movieDetails = model?.movieDetails;
    final releaseDateRoot = model?.releaseDateRoot?.results;
    final releaseDate = model?.formatDate(movieDetails?.releaseDate);
    var countriesList = <String>[];
    var genresList = <String>[];

    if(movieDetails != null) {
      for (var country in movieDetails.productionCountries) {
        countriesList.add(country.iso);
      }

      for(var genre in movieDetails.genres) {
        genresList.add(genre.name);
      }
    }

    String rating = "";
    if(releaseDateRoot != null) {
      try {
        rating = releaseDateRoot.firstWhere((element) => element.iso == "US").releaseDates.first.certification;
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
                  text: "${movieDetails?.runtime.toString()} min",
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

class _PeopleWidget extends StatelessWidget {
  const _PeopleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const styleOfName = TextStyle(fontSize: 16, );
    const styleOfRole = TextStyle(fontSize: 16, fontStyle: FontStyle.italic);

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Danny Philippou", style: styleOfName,),
                Text("Director, Writer", style: styleOfRole,),
              ],),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Danny Philippou", style: styleOfName,),
                Text("Director, Writer", style: styleOfRole,),
              ],
            ),
          ],
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Danny Philippou", style: styleOfName,),
                Text("Director, Writer", style: styleOfRole,),
              ],),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Danny Philippou", style: styleOfName,),
                Text("Director, Writer", style: styleOfRole,),
              ],
            ),
          ],
        )
      ],
    );
  }
}