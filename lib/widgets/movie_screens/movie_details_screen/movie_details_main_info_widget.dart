import 'package:flutter/material.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/action_buttons/favorite_button_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/action_buttons/list_button_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/action_buttons/rate_button_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/action_buttons/watchlist_button_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/crew_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/media_details_elements/media_details_list_widget.dart';
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
        OverviewWidget<MovieDetailsModel>(
          mediaDetailsElementType: MediaDetailsElementType.movie,
          model: model,
        ),
        MediaCrewWidget<MovieDetailsModel>(
          model: model,
          mediaDetailsElementType: MediaDetailsElementType.movie,
        ),
        MediaDetailsListWidget<MovieDetailsModel>(
          mediaDetailsElementType: MediaDetailsElementType.movie,
          horizontalListElementType: HorizontalListElementType.cast,
          model: model,
        ),
        MediaDetailsListWidget<MovieDetailsModel>(
          mediaDetailsElementType: MediaDetailsElementType.movie,
          horizontalListElementType: HorizontalListElementType.companies,
          model: model,
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

// class MovieDetailsMainInfoWidget extends StatelessWidget {
//   const MovieDetailsMainInfoWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _SummaryMovieWidget(),
//         _ScoreAndTrailerWidget(), //+
//         MovieActionButtonsWidget(),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//           child: Text("Overview", style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),),
//         ),
//         _TaglineWidget(), //+
//         _DescriptionWidget(), //+
//         _MovieCrewWidget(), //+
//         _MovieCastWidget(), //+
//         _ProductionCompanyWidget(), //+
//         SizedBox(height: 20,),
//       ],
//     );
//   }
// }
//
// class _ScoreAndTrailerWidget extends StatelessWidget {
//   const _ScoreAndTrailerWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final model = NotifierProvider.watch<MovieDetailsModel>(context);
//     final movieDetails = model?.movieDetails;
//     final voteAverage = movieDetails?.voteAverage ?? 0;
//     final voteAverageText = (voteAverage * 10).toStringAsFixed(0);
//     final voteAverageScore = voteAverage / 10;
//
//     final video = movieDetails?.videos.results
//         .where((element) => element.site == "YouTube" && element.type == "Trailer");
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         SizedBox(
//           height: 62,
//           child: TextButton(
//               onPressed: (){},
//             child: Row(
//               children: [
//                 SizedBox(
//                   width: 45,
//                   height: 45,
//                   child: RadiantPercentWidget(
//                     percent: voteAverageScore,
//                     progressFreeColor: Colors.grey,
//                     progressLine: voteAverage,
//                     backgroundCircleColor: Colors.black87,
//                     lineWidth: 3,
//                     child: Text(
//                       "$voteAverageText%",
//                       style: const TextStyle(color: Colors.white),),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 const Text("User Score", style: TextStyle(color: Colors.black),),
//               ],
//             )
//           ),
//         ),
//         Container(width: 1, height: 15,color: Colors.grey,),
//         SizedBox(
//           height: 62,
//           child: video != null && video.isNotEmpty
//               ? TextButton(
//                   onPressed: (){
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: const Text('Trailers'),
//                           content: Expanded(
//                             child: SingleChildScrollView(
//                               child: Column(
//                                 children: video.map((item) => ListTile(
//                                   title: Text(item.name),
//                                   subtitle: Text(item.isoTwo),
//                                   onTap: () => model?.launchYouTubeVideo(item.key),
//                                 ),).toList(),
//                               ),
//                             ),
//                           ),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                               child: const Text('Close'),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                   child: const Row(
//                     children: [
//                       Icon(Icons.play_arrow, color: Colors.black),
//                       Text("Play Trailer", style: TextStyle(color: Colors.black),),
//                     ],
//                   )
//                 )
//               : const SizedBox(
//                 width: 119,
//                 height: 62,
//                 child: Center(
//                   child: SizedBox(
//                     width: 95,
//                     height: 24,
//                     child: Center(
//                       child: Row(
//                         children: [
//                           Icon(Icons.play_arrow_outlined),
//                           Text(
//                             "No Trailer",
//                             style: TextStyle(color: Colors.black),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//         ),
//       ],
//     );
//   }
// }
//
// class _DescriptionWidget extends StatefulWidget {
//   const _DescriptionWidget({Key? key}) : super(key: key);
//
//   @override
//   _DescriptionWidgetState createState() => _DescriptionWidgetState();
// }
//
// class _DescriptionWidgetState extends State<_DescriptionWidget> {
//   bool _isExpanded = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final overview = NotifierProvider.watch<MovieDetailsModel>(context)?.movieDetails?.overview;
//
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: InkWell(
//         onTap: () {
//           setState(() {
//             _isExpanded = !_isExpanded;
//           });
//         },
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             AnimatedCrossFade(
//               duration: const Duration(milliseconds: 300),
//               crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
//               firstChild: Text(
//                 overview ?? "", // показываем только часть описания
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 3,
//               ),
//               secondChild: Text(
//                 overview ?? "", // показываем полное описание
//               ),
//             ),
//             overview != null && overview.length <= 190
//                 ? const SizedBox.shrink()
//                 : Icon(
//                     _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _TaglineWidget extends StatelessWidget {
//   const _TaglineWidget({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final movieDetails = NotifierProvider.watch<MovieDetailsModel>(context)?.movieDetails;
//     final tagline = movieDetails?.tagline;
//
//     if (tagline == null || tagline == "") {
//       return const SizedBox.shrink();
//     } else {
//       return Padding(
//         padding: const EdgeInsets.all(10),
//         child: Text("\"$tagline\"",
//           style: const TextStyle(fontSize: 21, fontStyle: FontStyle.italic),),
//       );
//     }
//   }
// }
//
// class _SummaryMovieWidget extends StatelessWidget {
//   const _SummaryMovieWidget({super.key});
//   final double textSize = 16;
//
//   @override
//   Widget build(BuildContext context) {
//     final model = NotifierProvider.watch<MovieDetailsModel>(context);
//     final movieDetails = model?.movieDetails;
//     final releaseDates = model?.movieDetails?.releaseDates?.results;
//     final releaseDate = model?.formatDate(movieDetails?.releaseDate);
//     var countriesList = <String>[];
//     var genresList = <String>[];
//
//     if(movieDetails != null) {
//       for (var country in movieDetails.productionCountries) {
//         countriesList.add(country.iso);
//       }
//
//       for(var genre in movieDetails.genres) {
//         genresList.add(genre.name);
//       }
//     }
//
//     String rating = "";
//     if(releaseDates != null) {
//       try {
//         rating = releaseDates.firstWhere((element) => element.iso == "US").releaseDates.first.certification;
//       } catch (e) {
//         rating = "";
//       }
//     }
//
//     final countries = countriesList.join(" | ");
//     final genres = genresList.join(" | ");
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
//       child: RichText(
//         textAlign: TextAlign.center,
//         text: TextSpan(
//           style: const TextStyle(color: Colors.black),
//             children: [
//               TextSpan(
//                 text: rating,
//                 style: TextStyle(
//                   fontSize: textSize,
//                 ),
//               ),
//               TextSpan(
//                 text: rating.isNotEmpty ? " ● " : "",
//                 // text: movieDetails?.runtime != null ? " ● " : "",
//                 style: TextStyle(fontSize: textSize,),
//               ),
//               TextSpan(
//                   text: "${movieDetails?.runtime.toString()} min",
//                   style: TextStyle(
//                     fontSize: textSize,
//                   )
//               ),
//               TextSpan(
//                 text: releaseDate != "" ? " ● " : "",
//                 style: TextStyle(fontSize: textSize,),
//               ),
//               TextSpan(
//                   text: releaseDate,
//                   style: TextStyle(
//                     fontSize: textSize,
//                   )
//               ),
//               TextSpan(
//                 text: countries.isNotEmpty ? " ● " : "",
//                 style: TextStyle(fontSize: textSize,),
//               ),
//               TextSpan(
//                   text: countries.isNotEmpty ? countries : "",
//                   style: TextStyle(
//                     fontSize: textSize,
//                   )
//               ),
//               TextSpan(
//                 text: genres.isNotEmpty ? " ● " : "",
//                 style: TextStyle(fontSize: textSize,),
//               ),
//               TextSpan(
//                   text: genres.isNotEmpty ? genres : "",
//                   style: TextStyle(
//                     fontSize: textSize,
//                   )
//               ),
//             ]
//         ),
//       ),
//     );
//   }
// }
//
// class _MovieCrewWidget extends StatelessWidget {
//   const _MovieCrewWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final model = NotifierProvider.watch<MovieDetailsModel>(context);
//     final crew = model?.movieDetails?.credits.crew;
//
//     const styleOfName = TextStyle(fontSize: 16,);
//     const styleOfRole = TextStyle(fontSize: 16, fontStyle: FontStyle.italic);
//
//     if (crew == null) {
//       return const SizedBox.shrink();
//     } else if(crew.isEmpty) {
//       return const SizedBox.shrink();
//     } else if (crew.length == 1) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
//             child: InkWell(
//               borderRadius: BorderRadius.circular(24),
//               onTap: () => model?.onCrewListTab(context, crew),
//               child: const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 child: Text(
//                   "Movie Crew",
//                   style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 55,
//             child: Padding (
//               padding: const EdgeInsets.only(left: 56),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   SizedBox(
//                     width: 130,
//                     height: 50,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(crew[0].name ?? "", style: styleOfName,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,),
//                         Text(crew[0].job, style: styleOfRole,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       );
//     }
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
//           child: InkWell(
//             borderRadius: BorderRadius.circular(24),
//             onTap: () => model?.onCrewListTab(context, crew),
//             child: const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               child: Text(
//                 "Movie Crew",
//                 style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 135,
//           child: ListView.builder(
//             itemCount: crew.length ~/ 2,
//             scrollDirection: Axis.horizontal,
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding: const EdgeInsets.only(left: 56),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     SizedBox(
//                       width: 130,
//                       height: 50,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(crew[index * 2].name ?? "", style: styleOfName,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           Text(crew[index * 2].job, style: styleOfRole,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       width: 130,
//                       height: 50,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(crew[index * 2 + 1].name ?? "", style: styleOfName,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           Text(crew[index * 2 + 1].job, style: styleOfRole,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _MovieCastWidget extends StatelessWidget {
//   const _MovieCastWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final model = NotifierProvider.watch<MovieDetailsModel>(context);
//     final cast = model?.movieDetails?.credits.cast;
//
//     if(cast == null) {
//       return const SizedBox.shrink();
//     } else if (cast.isEmpty) {
//       return const SizedBox.shrink();
//     }
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
//           child: InkWell(
//             borderRadius: BorderRadius.circular(24),
//             onTap: () => model?.onCastListTab(context, cast),
//             child: const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               child: Text(
//                 "Movie Cast",
//                 style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 250,
//           child: Scrollbar(
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: cast.length,
//               itemExtent: 125,
//               itemBuilder: (BuildContext context, int index){
//                 final profilePath = cast[index].profilePath;
//                 final character = cast[index].character;
//                 final name = cast[index].name;
//
//                 return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Stack(
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               border: Border.all(color: Colors.black.withOpacity(0.2)),
//                               borderRadius: const BorderRadius.all(Radius.circular(10)),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.1),
//                                   blurRadius: 8,
//                                   offset: const Offset(1, 2),
//                                 )
//                               ]
//                           ),
//                           clipBehavior: Clip.hardEdge,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               AspectRatio(
//                                 aspectRatio: 500 / 750,
//                                 child: profilePath != null
//                                     ? Image.network(
//                                         loadingBuilder: (context, child, loadingProgress) {
//                                           if (loadingProgress == null) return child;
//                                           return const Center(
//                                             child: SizedBox(
//                                               width: 60,
//                                               height: 60,
//                                               child: CircularProgressIndicator(),
//                                             ),
//                                           );
//                                         },
//                                   ApiClient.getImageByUrl(profilePath),)
//                                     : Image.asset(AppImages.noProfile,),
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(height: 10,),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 4),
//                                     child: Text(
//                                       name ?? "",
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: const TextStyle(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w700
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 10,),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 4),
//                                     child: Text(
//                                       character.isNotEmpty ? character : "",
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: const TextStyle(
//                                           fontSize: 14,
//                                           fontStyle: FontStyle.italic
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         Material(
//                           color: Colors.transparent,
//                           child: InkWell(
//                             borderRadius: const BorderRadius.all(Radius.circular(10)),
//                             onTap: () => model?.onPeopleDetailsTab(context, index),
//                           ),
//                         ),
//                       ],
//                     )
//                 );
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _ProductionCompanyWidget extends StatelessWidget {
//   const _ProductionCompanyWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final productionCompanies = NotifierProvider.watch<MovieDetailsModel>(context)?.movieDetails?.productionCompanies;
//
//     if(productionCompanies == null) {
//       return const SizedBox.shrink();
//     } else if (productionCompanies.isEmpty) {
//       return const SizedBox.shrink();
//     }
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
//           child: InkWell(
//             borderRadius: BorderRadius.circular(24),
//             onTap: () {},
//             child: const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               child: Text(
//                 "Production Companies",
//                 style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 215,
//           child: Scrollbar(
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: productionCompanies.length,
//               itemExtent: 125,
//               itemBuilder: (BuildContext context, int index){
//                 final logoPath = productionCompanies[index].logoPath;
//                 final originCountry = productionCompanies[index].originCountry;
//                 final name = productionCompanies[index].name;
//
//                 return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           border: Border.all(color: Colors.black.withOpacity(0.2)),
//                           borderRadius: const BorderRadius.all(Radius.circular(10)),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               blurRadius: 8,
//                               offset: const Offset(1, 2),
//                             )
//                           ]
//                       ),
//                       clipBehavior: Clip.hardEdge,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           AspectRatio(
//                             aspectRatio: 1 / 1,
//                             child: logoPath != null
//                                 ? Padding(
//                                     padding: const EdgeInsets.all(4.0),
//                                     child: Image.network(
//                                       loadingBuilder: (context, child, loadingProgress) {
//                                         if (loadingProgress == null) return child;
//                                         return const Center(
//                                           child: SizedBox(
//                                             width: 60,
//                                             height: 60,
//                                             child: CircularProgressIndicator(),
//                                           ),
//                                         );
//                                       },
//                                       ApiClient.getImageByUrl(logoPath),),
//                                   )
//                                 : Image.asset(AppImages.noLogo,),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const SizedBox(height: 10,),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 4),
//                                 child: Text(
//                                   name.isNotEmpty ? name : "",
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w700
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 10,),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 4),
//                                 child: Text(
//                                   originCountry.isNotEmpty ? originCountry : "",
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(
//                                       fontSize: 14,
//                                       fontStyle: FontStyle.italic
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     )
//                 );
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }