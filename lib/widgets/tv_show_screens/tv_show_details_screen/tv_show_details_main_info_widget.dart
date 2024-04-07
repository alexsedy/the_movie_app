import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/score_radial_percent_widget.dart';
import 'package:the_movie_app/widgets/tv_show_screens/tv_show_details_screen/tv_show_action_info/tv_show_action_buttons_widget.dart';
import 'package:the_movie_app/widgets/tv_show_screens/tv_show_details_screen/tv_show_details_model.dart';

class TvShowDetailsMainInfoWidget extends StatelessWidget {
  const TvShowDetailsMainInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SummaryTvShowWidget(),
        _ScoreAndTrailerWidget(), //+
        TvShowActionButtonsWidget(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text("Overview", style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),),
        ),
        _TaglineWidget(),//+
        _DescriptionWidget(),//+
        _TvShowCrewWidget(),
        _TvShowCastWidget(),
        _SeasonsWidget(),
        _NetworkWidget(),
        _ProductionCompanyWidget(),
      ],
    );
  }
}

class _ScoreAndTrailerWidget extends StatelessWidget {
  const _ScoreAndTrailerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<TvShowDetailsModel>(context);
    final tvShowDetails = model?.tvShowDetails;
    final voteAverage = tvShowDetails?.voteAverage ?? 0;
    final voteAverageText = (voteAverage * 10).toStringAsFixed(0);
    final voteAverageScore = voteAverage / 10;

    final video = tvShowDetails?.videos.results
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
                                  onTap: () => model?.launchYouTubeVideo(item.key),
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

// class _DescriptionWidget extends StatelessWidget {
//   const _DescriptionWidget({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final tvShowDetails = NotifierProvider.watch<TvShowDetailsModel>(context)?.tvShowDetails;
//
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Text(tvShowDetails?.overview ?? ""),
//     );
//   }
// }

class _DescriptionWidget extends StatefulWidget {
  const _DescriptionWidget({Key? key}) : super(key: key);

  @override
  _DescriptionWidgetState createState() => _DescriptionWidgetState();
}

class _DescriptionWidgetState extends State<_DescriptionWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final overview = NotifierProvider.watch<TvShowDetailsModel>(context)?.tvShowDetails?.overview;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              firstChild: Text(
                overview ?? "", // показываем только часть описания
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
              secondChild: Text(
                overview ?? "", // показываем полное описание
              ),
            ),
            overview != null && overview.length <= 190
                ? const SizedBox.shrink()
                : Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            ),
          ],
        ),
      ),
    );
  }
}

class _TaglineWidget extends StatelessWidget {
  const _TaglineWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final movieDetails = NotifierProvider.watch<TvShowDetailsModel>(context)?.tvShowDetails;
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

class _SummaryTvShowWidget extends StatelessWidget {
  const _SummaryTvShowWidget({super.key});
  final double textSize = 16;

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<TvShowDetailsModel>(context);
    final tvShowDetails = model?.tvShowDetails;
    final firstAirDate = model?.tvShowDetails?.firstAirDate;
    // final lastAirDate = model?.tvShowDetails?.lastAirDate;
    final ratingsList = tvShowDetails?.contentRatings?.ratingsList;

    var countriesList = <String>[];
    var genresList = <String>[];

    if(tvShowDetails != null) {
      for (var country in tvShowDetails.productionCountries) {
        countriesList.add(country.iso);
      }

      for(var genre in tvShowDetails.genres) {
        genresList.add(genre.name);
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

class _TvShowCrewWidget extends StatelessWidget {
  const _TvShowCrewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<TvShowDetailsModel>(context);
    final crew = model?.tvShowDetails?.credits.crew;

    const styleOfName = TextStyle(fontSize: 16,);
    const styleOfRole = TextStyle(fontSize: 16, fontStyle: FontStyle.italic);

    if (crew == null) {
      return const SizedBox.shrink();
    } else if(crew.isEmpty) {
      return const SizedBox.shrink();
    } else if (crew.length == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => model?.onCrewListTab(context, crew),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  "TV Show Crew",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 55,
            child: Padding (
              padding: const EdgeInsets.only(left: 56),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 130,
                    height: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(crew[0].name ?? "", style: styleOfName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,),
                        Text(crew[0].job, style: styleOfRole,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => model?.onCrewListTab(context, crew),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                "TV Show Crew",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 135,
          child: ListView.builder(
            itemCount: crew.length ~/ 2,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 56),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 130,
                      height: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(crew[index * 2].name ?? "", style: styleOfName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(crew[index * 2].job, style: styleOfRole,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 130,
                      height: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(crew[index * 2 + 1].name ?? "", style: styleOfName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(crew[index * 2 + 1].job, style: styleOfRole,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TvShowCastWidget extends StatelessWidget {
  const _TvShowCastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<TvShowDetailsModel>(context);
    final cast = model?.tvShowDetails?.credits.cast;

    if(cast == null) {
      return const SizedBox.shrink();
    } else if (cast.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => model?.onCastListTab(context, cast),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                "TV Show Cast",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 250,
          child: Scrollbar(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cast.length,
              itemExtent: 125,
              itemBuilder: (BuildContext context, int index){
                final profilePath = cast[index].profilePath;
                final character = cast[index].character;
                final name = cast[index].name;

                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black.withOpacity(0.2)),
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(1, 2),
                                )
                              ]
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 500 / 750,
                                child: profilePath != null
                                    ? Image.network(
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return const Center(
                                            child: SizedBox(
                                              width: 60,
                                              height: 60,
                                              child: CircularProgressIndicator(),
                                            ),
                                          );
                                        },
                                        ApiClient.getImageByUrl(profilePath),)
                                    : Image.asset(AppImages.noProfile,),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Text(
                                      name ?? "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Text(
                                      character.isNotEmpty ? character : "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            onTap: () => model?.onPeopleDetailsTab(context, index),
                          ),
                        ),
                      ],
                    )
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _SeasonsWidget extends StatelessWidget {
  const _SeasonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tvShowDetails = NotifierProvider.watch<TvShowDetailsModel>(context)?.tvShowDetails;
    final seasons = tvShowDetails?.seasons;
    final numberOfSeasons = tvShowDetails?.numberOfSeasons;

    if(seasons == null) {
      return const SizedBox.shrink();
    } else if (seasons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text("Seasons ($numberOfSeasons)",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 280,
          child: Scrollbar(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: seasons.length,
              itemExtent: 125,
              itemBuilder: (BuildContext context, int index){
                final posterPath = seasons[index].posterPath;
                final seasonName = seasons[index].name;
                final airDate = seasons[index].airDate;
                final episodeCount = seasons[index].episodeCount;
                final voteAverage = seasons[index].voteAverage;
                final voteAverageText = (voteAverage * 10).toStringAsFixed(0);
                final voteAverageScore = seasons[index].voteAverage / 10;

                String? airDateText;
                if(airDate != null) {
                  airDateText = NotifierProvider.read<TvShowDetailsModel>(context)?.formatDateTwo(airDate);
                }

                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black.withOpacity(0.2)),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(1, 2),
                            ),
                          ]
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 500 / 750,
                            child: posterPath != null
                                ? Image.network(
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                                    ApiClient.getImageByUrl(posterPath), width: 95,)
                                : Image.asset(AppImages.noPoster, width: 95,),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  seasonName.isNotEmpty ? seasonName : "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  "$episodeCount episodes",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  airDateText ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _NetworkWidget extends StatelessWidget {
  const _NetworkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final networks = NotifierProvider.watch<TvShowDetailsModel>(context)?.tvShowDetails?.networks;

    if(networks == null) {
      return const SizedBox.shrink();
    } else if (networks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                "Networks",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 215,
          child: Scrollbar(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: networks.length,
              itemExtent: 125,
              itemBuilder: (BuildContext context, int index){
                final logoPath = networks[index].logoPath;
                final originCountry = networks[index].originCountry;
                final name = networks[index].name;

                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black.withOpacity(0.2)),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(1, 2),
                            )
                          ]
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 1 / 1,
                            child: logoPath != null
                                ? Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Image.network(
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                                    ApiClient.getImageByUrl(logoPath),),
                                )
                                : Image.asset(AppImages.noLogo,),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  name.isNotEmpty ? name : "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  originCountry.isNotEmpty ? originCountry : "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductionCompanyWidget extends StatelessWidget {
  const _ProductionCompanyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final productionCompanies = NotifierProvider.watch<TvShowDetailsModel>(context)?.tvShowDetails?.productionCompanies;

    if(productionCompanies == null) {
      return const SizedBox.shrink();
    } else if (productionCompanies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                "Production Companies",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 215,
          child: Scrollbar(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productionCompanies.length,
              itemExtent: 125,
              itemBuilder: (BuildContext context, int index){
                final logoPath = productionCompanies[index].logoPath;
                final originCountry = productionCompanies[index].originCountry;
                final name = productionCompanies[index].name;

                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black.withOpacity(0.2)),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(1, 2),
                            )
                          ]
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 1 / 1,
                            child: logoPath != null
                                ? Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Image.network(
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return const Center(
                                          child: SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      },
                                      ApiClient.getImageByUrl(logoPath),),
                                  )
                                : Image.asset(AppImages.noLogo,),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  name.isNotEmpty ? name : "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  originCountry.isNotEmpty ? originCountry : "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}