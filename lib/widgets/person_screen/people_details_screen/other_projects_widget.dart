import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/domain/entity/person/credits_people/credits.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/person_screen/people_details_screen/people_details_model.dart';

class OtherProjectsWidget extends StatelessWidget {
  const OtherProjectsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Other projects",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _MoviesButtonWidget(),
            _TvShowButtonWidget(),
          ],
        ),
        SizedBox(height: 30,),
      ],
    );
  }
}

class _MoviesButtonWidget extends StatelessWidget {
  const _MoviesButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model =  NotifierProvider.watch<PeopleDetailsModel>(context);
    final movieCreditList = model?.movieCreditList;

    if(movieCreditList == null) {
      return const SizedBox.shrink();
    } else if (movieCreditList.isEmpty) {
      return InkWell(
        onTap: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              isDismissible: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
              ),
              backgroundColor: Colors.transparent,
              builder: (context) {
                return DraggableScrollableSheet(
                  initialChildSize: 0.45,
                  minChildSize: 0.2,
                  maxChildSize: 0.95,
                  builder: (context, scrollController) {
                    return Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dialogBackgroundColor,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Center(
                        child: Text(
                          "No other movie projects",
                          style: TextStyle(fontSize: 34),
                        ),
                      ),
                    );
                  },
                );
              }
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(),
          ),
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                "Movies",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            backgroundColor: Colors.transparent,
            builder: (context) {
              return DraggableScrollableSheet(
                initialChildSize: 0.45,
                minChildSize: 0.2,
                maxChildSize: 0.95,
                builder: (context, scrollController) {
                  return Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dialogBackgroundColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: GroupedListView<CreditList, String>(
                      controller: scrollController,
                      useStickyGroupSeparators: true,
                      elements: movieCreditList,
                      groupBy: (CreditList c) => c.department,
                      groupHeaderBuilder: (c) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Text(
                            c.department,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                      indexedItemBuilder: (context, _, index) {
                        final releaseDate = model?.formatDateInString(movieCreditList[index].releaseDate);
                        final title = movieCreditList[index].title;
                        final department = movieCreditList[index].department;
                        final job = movieCreditList[index].job;
                        final character = movieCreditList[index].character;
                        final posterPath = movieCreditList[index].posterPath;

                        return SizedBox(
                          height: 150,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            child: Card(
                              clipBehavior: Clip.hardEdge,
                              child: ListTile(
                                onTap: () => model?.onMovieDetailsTab(context, index),
                                minVerticalPadding: 0,
                                contentPadding: EdgeInsets.zero,
                                title: Row(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    posterPath != null
                                        ? AspectRatio(
                                            aspectRatio: 500 / 750,
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
                                        ApiClient.getImageByUrl(posterPath),
                                      ),
                                    )
                                        : Image.asset(AppImages.noPoster),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(releaseDate != null && releaseDate.isNotEmpty
                                                ? releaseDate : "Unknown",
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            const SizedBox(height: 10,),
                                            Text(
                                              title ?? "",
                                              softWrap: true,
                                              maxLines: 3,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(department != "Actor"
                                                ? job ?? ""
                                                : character ?? "",
                                              softWrap: true,
                                              maxLines: 3,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(),
        ),
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Text(
              "Movies",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class _MoviesButtonWidget extends StatelessWidget {
//   const _MoviesButtonWidget({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final model =  NotifierProvider.watch<PeopleDetailsModel>(context);
//     final movieCreditList = model?.movieCreditList;
//
//     if(movieCreditList == null) {
//       return const SizedBox.shrink();
//     }
//
//     return InkWell(
//       onTap: () {
//         showModalBottomSheet(
//             context: context,
//             isScrollControlled: true,
//             isDismissible: true,
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
//             ),
//             backgroundColor: Colors.transparent,
//             builder: (context) {
//               return DraggableScrollableSheet(
//                 initialChildSize: 0.45,
//                 minChildSize: 0.2,
//                 maxChildSize: 0.95,
//                 builder: (context, scrollController) {
//                   return Container(
//                     clipBehavior: Clip.hardEdge,
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).dialogBackgroundColor,
//                       borderRadius: BorderRadius.circular(24),
//                     ),
//                     child: GroupedListView<MovieCreditList, String>(
//                       sort: true,
//                       controller: scrollController,
//                       useStickyGroupSeparators: true,
//                       elements: movieCreditList,
//                       groupBy: (MovieCreditList c) => c.department,
//                       groupHeaderBuilder: (c) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 8, horizontal: 16),
//                           child: Text(
//                             c.department,
//                             style: const TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                         );
//                       },
//                       indexedItemBuilder: (context, _, index) {
//                         final releaseDate = model?.formatDateInString(movieCreditList[index].releaseDate);
//                         final title = movieCreditList[index].title;
//                         final department = movieCreditList[index].department;
//                         final job = movieCreditList[index].job;
//                         final character = movieCreditList[index].character;
//
//                         return InkWell(
//                           onTap: () => model?.onMovieDetailsTab(context, index),
//                           child: Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 SizedBox(
//                                   width: 40,
//                                   child: Text(releaseDate ?? ""),
//                                 ),
//                                 const Padding(
//                                   padding: EdgeInsets.only(right: 10),
//                                   child: SizedBox(
//                                     width: 10,
//                                     child: Icon(Icons.circle, size: 10,),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         title ?? "",
//                                         softWrap: true,
//                                         maxLines: 3,
//                                       ),
//                                       Text(department != "Actor"
//                                           ? job ?? ""
//                                           : character ?? "",
//                                         softWrap: true,
//                                         maxLines: 3,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               );
//             }
//         );
//       },
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         width: 150,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(),
//         ),
//         child: const Padding(
//           padding: EdgeInsets.all(10),
//           child: Center(
//             child: Text(
//               "Movies",
//               style: TextStyle(
//                 fontSize: 20,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class _TvShowButtonWidget extends StatelessWidget {
  const _TvShowButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<PeopleDetailsModel>(context);
    final tvShowCreditList = model?.tvShowCreditList;

    if(tvShowCreditList == null) {
      return const SizedBox.shrink();
    } else if (tvShowCreditList.isEmpty) {
      return InkWell(
        onTap: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              isDismissible: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
              ),
              backgroundColor: Colors.transparent,
              builder: (context) {
                return DraggableScrollableSheet(
                  initialChildSize: 0.45,
                  minChildSize: 0.2,
                  maxChildSize: 0.95,
                  builder: (context, scrollController) {
                    return Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dialogBackgroundColor,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Center(
                        child: Text(
                          "No other TV show projects",
                          style: TextStyle(fontSize: 34),
                        ),
                      ),
                    );
                  },
                );
              }
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(),
          ),
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                "TV Shows",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            backgroundColor: Colors.transparent,
            builder: (context) {
              return DraggableScrollableSheet(
                initialChildSize: 0.45,
                minChildSize: 0.2,
                maxChildSize: 0.95,
                builder: (context, scrollController) {
                  return Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dialogBackgroundColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: GroupedListView<CreditList, String>(
                      sort: true,
                      controller: scrollController,
                      useStickyGroupSeparators: true,
                      elements: tvShowCreditList,
                      groupBy: (CreditList c) => c.department,
                      groupHeaderBuilder: (c) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Text(
                            c.department,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                      indexedItemBuilder: (context, _, index) {
                        final firstAirDate = model?.formatDateInString(tvShowCreditList[index].firstAirDate);
                        final name = tvShowCreditList[index].name;
                        final department = tvShowCreditList[index].department;
                        final job = tvShowCreditList[index].job;
                        final character = tvShowCreditList[index].character;
                        final posterPath = tvShowCreditList[index].posterPath;

                        final episodeCount = tvShowCreditList[index].episodeCount;
                        String episodeCountText = "";
                        if(episodeCount != null) {
                          episodeCountText = episodeCount == 1
                              ? "($episodeCount episode)"
                              : "($episodeCount episodes)";
                        }


                        return SizedBox(
                          height: 150,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            child: Card(
                              clipBehavior: Clip.hardEdge,
                              child: ListTile(
                                onTap: () => model?.onMovieDetailsTab(context, index),
                                minVerticalPadding: 0,
                                contentPadding: EdgeInsets.zero,
                                title: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    posterPath != null
                                        ? AspectRatio(
                                            aspectRatio: 500 / 750,
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
                                        ApiClient.getImageByUrl(posterPath),
                                      ),
                                    )
                                        : Image.asset(AppImages.noPoster),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(firstAirDate != null && firstAirDate.isNotEmpty
                                                ? firstAirDate : "Unknown",
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            const SizedBox(height: 10,),
                                            Text(
                                              name ?? "",
                                              softWrap: true,
                                              maxLines: 3,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(department != "Actor"
                                                ? "${job ?? ""} $episodeCountText"
                                                : "${character ?? ""} $episodeCountText",
                                              softWrap: true,
                                              maxLines: 3,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(),
        ),
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Text(
              "TV Shows",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}